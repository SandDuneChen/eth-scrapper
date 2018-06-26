
//Address: 0x5aeb706c39a76c31fa89bf726de1a6f7d6bc1a51
//Contract name: EtherColor
//Balance: 0 Ether
//Verification Date: 2/17/2018
//Transacion Count: 1109

// CODE STARTS HERE

pragma solidity ^0.4.18;

/// Colors :3

/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
/// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
contract ERC721 {
  // Required methods
  function approve(address _to, uint256 _tokenId) public;
  function balanceOf(address _owner) public view returns (uint256 balance);
  function implementsERC721() public pure returns (bool);
  function ownerOf(uint256 _tokenId) public view returns (address addr);
  function takeOwnership(uint256 _tokenId) public;
  function totalSupply() public view returns (uint256 total);
  function transferFrom(address _from, address _to, uint256 _tokenId) public;
  function transfer(address _to, uint256 _tokenId) public;

  event Transfer(address indexed from, address indexed to, uint256 tokenId);
  event Approval(address indexed owner, address indexed approved, uint256 tokenId);

  // Optional
  // function name() public view returns (string name);
  // function symbol() public view returns (string symbol);
  // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
  // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
}

/// Modified from the CryptoCelebrities contract
/// And again modified from the EmojiBlockhain contract
contract EtherColor is ERC721 {

  /*** EVENTS ***/

  /// @dev The Birth event is fired whenever a new color comes into existence.
  event Birth(uint256 tokenId, string name, address owner);

  /// @dev The TokenSold event is fired whenever a token is sold.
  event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);

  /// @dev Transfer event as defined in current draft of ERC721.
  ///  ownership is assigned, including births.
  event Transfer(address from, address to, uint256 tokenId);

  /*** CONSTANTS ***/

  /// @notice Name and symbol of the non fungible token, as defined in ERC721.
  string public constant NAME = "EtherColors"; // solhint-disable-line
  string public constant SYMBOL = "EtherColor"; // solhint-disable-line

  uint256 private startingPrice = 0.001 ether;
  uint256 private firstStepLimit =  0.05 ether;
  uint256 private secondStepLimit = 0.5 ether;

  /*** STORAGE ***/

  /// @dev A mapping from color IDs to the address that owns them. All colors have
  ///  some valid owner address.
  mapping (uint256 => address) public colorIndexToOwner;

  // @dev A mapping from owner address to count of tokens that address owns.
  //  Used internally inside balanceOf() to resolve ownership count.
  mapping (address => uint256) private ownershipTokenCount;

  /// @dev A mapping from ColorIDs to an address that has been approved to call
  ///  transferFrom(). Each Color can only have one approved address for transfer
  ///  at any time. A zero value means no approval is outstanding.
  mapping (uint256 => address) public colorIndexToApproved;

  // @dev A mapping from ColorIDs to the price of the token.
  mapping (uint256 => uint256) private colorIndexToPrice;

  /// @dev A mapping from ColorIDs to the previpus price of the token. Used
  /// to calculate price delta for payouts
  mapping (uint256 => uint256) private colorIndexToPreviousPrice;

  // @dev A mapping from colorId to the 7 last owners.
  mapping (uint256 => address[5]) private colorIndexToPreviousOwners;


  // The addresses of the accounts (or contracts) that can execute actions within each roles.
  address public ceoAddress;
  address public cooAddress;

  /*** DATATYPES ***/
  struct Color {
    string name;
  }

  Color[] private colors;

  /*** ACCESS MODIFIERS ***/
  /// @dev Access modifier for CEO-only functionality
  modifier onlyCEO() {
    require(msg.sender == ceoAddress);
    _;
  }

  /// @dev Access modifier for COO-only functionality
  modifier onlyCOO() {
    require(msg.sender == cooAddress);
    _;
  }

  /// Access modifier for contract owner only functionality
  modifier onlyCLevel() {
    require(
      msg.sender == ceoAddress ||
      msg.sender == cooAddress
    );
    _;
  }

  /*** CONSTRUCTOR ***/
  function EtherColor() public {
    ceoAddress = msg.sender;
    cooAddress = msg.sender;
  }

  /*** PUBLIC FUNCTIONS ***/
  /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
  /// @param _to The address to be granted transfer approval. Pass address(0) to
  ///  clear all approvals.
  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
  /// @dev Required for ERC-721 compliance.
  function approve(
    address _to,
    uint256 _tokenId
  ) public {
    // Caller must own token.
    require(_owns(msg.sender, _tokenId));

    colorIndexToApproved[_tokenId] = _to;

    Approval(msg.sender, _to, _tokenId);
  }

  /// For querying balance of a particular account
  /// @param _owner The address for balance query
  /// @dev Required for ERC-721 compliance.
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return ownershipTokenCount[_owner];
  }

  /// @dev Creates a new Color with the given name.
  function createContractColor(string _name) public onlyCOO {
    _createColor(_name, address(this), startingPrice);
  }

  /// @notice Returns all the relevant information about a specific color.
  /// @param _tokenId The tokenId of the color of interest.
  function getColor(uint256 _tokenId) public view returns (
    string colorName,
    uint256 sellingPrice,
    address owner,
    uint256 previousPrice,
    address[5] previousOwners
  ) {
    Color storage color = colors[_tokenId];
    colorName = color.name;
    sellingPrice = colorIndexToPrice[_tokenId];
    owner = colorIndexToOwner[_tokenId];
    previousPrice = colorIndexToPreviousPrice[_tokenId];
    previousOwners = colorIndexToPreviousOwners[_tokenId];
  }

  function implementsERC721() public pure returns (bool) {
    return true;
  }

  /// @dev Required for ERC-721 compliance.
  function name() public pure returns (string) {
    return NAME;
  }

  /// For querying owner of token
  /// @param _tokenId The tokenID for owner inquiry
  /// @dev Required for ERC-721 compliance.
  function ownerOf(uint256 _tokenId)
    public
    view
    returns (address owner)
  {
    owner = colorIndexToOwner[_tokenId];
    require(owner != address(0));
  }

  function payout(address _to) public onlyCLevel {
    _payout(_to);
  }

  // Allows someone to send ether and obtain the token
  function purchase(uint256 _tokenId) public payable {
    address oldOwner = colorIndexToOwner[_tokenId];
    address newOwner = msg.sender;

    address[5] storage previousOwners = colorIndexToPreviousOwners[_tokenId];

    uint256 sellingPrice = colorIndexToPrice[_tokenId];
    uint256 previousPrice = colorIndexToPreviousPrice[_tokenId];
    // Making sure token owner is not sending to self
    require(oldOwner != newOwner);

    // Safety check to prevent against an unexpected 0x0 default.
    require(_addressNotNull(newOwner));

    // Making sure sent amount is greater than or equal to the sellingPrice
    require(msg.value >= sellingPrice);

    uint256 priceDelta = SafeMath.sub(sellingPrice, previousPrice);
    uint256 ownerPayout = SafeMath.add(previousPrice, SafeMath.mul(SafeMath.div(priceDelta, 100), 49));
    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);

    // Update prices
    if (sellingPrice < firstStepLimit) {
      // first stage
      colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
    } else if (sellingPrice < secondStepLimit) {
      // second stage
      colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
    } else {
      // third stage
      colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);
    }
    colorIndexToPreviousPrice[_tokenId] = sellingPrice;

    uint256 fee_for_dev;
    // Pay previous tokenOwner if owner is not contract
    // and if previous price is not 0
    if (oldOwner != address(this)) {
      // old owner gets entire initial payment back
      oldOwner.transfer(ownerPayout);
      fee_for_dev = SafeMath.mul(SafeMath.div(priceDelta, 100), 1);
    } else {
      fee_for_dev = SafeMath.add(ownerPayout, SafeMath.mul(SafeMath.div(priceDelta, 100), 1));
    }

    // Next distribute payout Total among previous Owners
    for (uint i = 0; i <= 4; i++) {
        if (previousOwners[i] != address(this)) {
            previousOwners[i].transfer(uint256(SafeMath.div(SafeMath.mul(priceDelta, 10), 100)));
        } else {
            fee_for_dev = SafeMath.add(fee_for_dev, uint256(SafeMath.div(SafeMath.mul(priceDelta, 10), 100)));
        }
    }
    ceoAddress.transfer(fee_for_dev);

    _transfer(oldOwner, newOwner, _tokenId);

    //TokenSold(_tokenId, sellingPrice, colorIndexToPrice[_tokenId], oldOwner, newOwner, colors[_tokenId].name);

    msg.sender.transfer(purchaseExcess);
  }

  function priceOf(uint256 _tokenId) public view returns (uint256 price) {
    return colorIndexToPrice[_tokenId];
  }

  /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
  /// @param _newCEO The address of the new CEO
  function setCEO(address _newCEO) public onlyCEO {
    require(_newCEO != address(0));

    ceoAddress = _newCEO;
  }

  /// @dev Assigns a new address to act as the COO. Only available to the current COO.
  /// @param _newCOO The address of the new COO
  function setCOO(address _newCOO) public onlyCEO {
    require(_newCOO != address(0));
    cooAddress = _newCOO;
  }

  /// @dev Required for ERC-721 compliance.
  function symbol() public pure returns (string) {
    return SYMBOL;
  }

  /// @notice Allow pre-approved user to take ownership of a token
  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
  /// @dev Required for ERC-721 compliance.
  function takeOwnership(uint256 _tokenId) public {
    address newOwner = msg.sender;
    address oldOwner = colorIndexToOwner[_tokenId];

    // Safety check to prevent against an unexpected 0x0 default.
    require(_addressNotNull(newOwner));

    // Making sure transfer is approved
    require(_approved(newOwner, _tokenId));

    _transfer(oldOwner, newOwner, _tokenId);
  }

  /// @param _owner The owner whose color tokens we are interested in.
  /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
  ///  expensive (it walks the entire Colors array looking for colors belonging to owner),
  ///  but it also returns a dynamic array, which is only supported for web3 calls, and
  ///  not contract-to-contract calls.
  function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
    uint256 tokenCount = balanceOf(_owner);
    if (tokenCount == 0) {
        // Return an empty array
      return new uint256[](0);
    } else {
      uint256[] memory result = new uint256[](tokenCount);
      uint256 totalColors = totalSupply();
      uint256 resultIndex = 0;
      uint256 colorId;
      for (colorId = 0; colorId <= totalColors; colorId++) {
        if (colorIndexToOwner[colorId] == _owner) {
          result[resultIndex] = colorId;
          resultIndex++;
        }
      }
      return result;
    }
  }

  /// For querying totalSupply of token
  /// @dev Required for ERC-721 compliance.
  function totalSupply() public view returns (uint256 total) {
    return colors.length;
  }

  /// Owner initates the transfer of the token to another account
  /// @param _to The address for the token to be transferred to.
  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
  /// @dev Required for ERC-721 compliance.
  function transfer(
    address _to,
    uint256 _tokenId
  ) public {
    require(_owns(msg.sender, _tokenId));
    require(_addressNotNull(_to));
    _transfer(msg.sender, _to, _tokenId);
  }

  /// Third-party initiates transfer of token from address _from to address _to
  /// @param _from The address for the token to be transferred from.
  /// @param _to The address for the token to be transferred to.
  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
  /// @dev Required for ERC-721 compliance.
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) public {
    require(_owns(_from, _tokenId));
    require(_approved(_to, _tokenId));
    require(_addressNotNull(_to));
    _transfer(_from, _to, _tokenId);
  }

  /*** PRIVATE FUNCTIONS ***/
  /// Safety check on _to address to prevent against an unexpected 0x0 default.
  function _addressNotNull(address _to) private pure returns (bool) {
    return _to != address(0);
  }

  /// For checking approval of transfer for address _to
  function _approved(address _to, uint256 _tokenId) private view returns (bool) {
    return colorIndexToApproved[_tokenId] == _to;
  }

  /// For creating Color
  function _createColor(string _name, address _owner, uint256 _price) private {
    Color memory _color = Color({
      name: _name
    });
    uint256 newColorId = colors.push(_color) - 1;

    // It's probably never going to happen, 4 billion tokens are A LOT, but
    // let's just be 100% sure we never let this happen.
    require(newColorId == uint256(uint32(newColorId)));

    Birth(newColorId, _name, _owner);

    colorIndexToPrice[newColorId] = _price;
    colorIndexToPreviousPrice[newColorId] = 0;
    colorIndexToPreviousOwners[newColorId] =
        [address(this), address(this), address(this), address(this), address(this)];

    // This will assign ownership, and also emit the Transfer event as
    // per ERC721 draft
    _transfer(address(0), _owner, newColorId);
  }

  /// Check for token ownership
  function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
    return claimant == colorIndexToOwner[_tokenId];
  }

  /// For paying out balance on contract
  function _payout(address _to) private {
    if (_to == address(0)) {
      ceoAddress.transfer(this.balance);
    } else {
      _to.transfer(this.balance);
    }
  }

  /// @dev Assigns ownership of a specific Color to an address.
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    // Since the number of colors is capped to 2^32 we can't overflow this
    ownershipTokenCount[_to]++;
    //transfer ownership
    colorIndexToOwner[_tokenId] = _to;
    // When creating new colors _from is 0x0, but we can't account that address.
    if (_from != address(0)) {
      ownershipTokenCount[_from]--;
      // clear any previously approved ownership exchange
      delete colorIndexToApproved[_tokenId];
    }
    // Update the colorIndexToPreviousOwners
    colorIndexToPreviousOwners[_tokenId][4]=colorIndexToPreviousOwners[_tokenId][3];
    colorIndexToPreviousOwners[_tokenId][3]=colorIndexToPreviousOwners[_tokenId][2];
    colorIndexToPreviousOwners[_tokenId][2]=colorIndexToPreviousOwners[_tokenId][1];
    colorIndexToPreviousOwners[_tokenId][1]=colorIndexToPreviousOwners[_tokenId][0];
    // the _from address for creation is 0, so instead set it to the contract address
    if (_from != address(0)) {
        colorIndexToPreviousOwners[_tokenId][0]=_from;
    } else {
        colorIndexToPreviousOwners[_tokenId][0]=address(this);
    }
    // Emit the transfer event.
    Transfer(_from, _to, _tokenId);
  }
}
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
