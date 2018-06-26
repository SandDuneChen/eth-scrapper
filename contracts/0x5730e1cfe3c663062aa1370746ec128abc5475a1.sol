
//Address: 0x5730e1cfe3c663062aa1370746ec128abc5475a1
//Contract name: Bounty
//Balance: 0 Ether
//Verification Date: 1/4/2018
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.15;

library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Ownable {

    //Variables
    address public owner;

    address public newOwner;

    //    Modifiers
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() public {
        owner = msg.sender;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }
}

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  /**
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;

  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(0x0, _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner public returns (bool) {
    mintingFinished = true;
    MintFinished();
    return true;
  }
}

contract LamdenTau is MintableToken {
    string public constant name = "Lamden Tau";
    string public constant symbol = "TAU";
    uint8 public constant decimals = 18;
}

contract Bounty is Ownable {

   LamdenTau public lamdenTau;

   function Bounty(address _tokenContractAddress) public {
      require(_tokenContractAddress != address(0));
      lamdenTau = LamdenTau(_tokenContractAddress);
      
      
   }

   function returnTokens() onlyOwner {
      uint256 balance = lamdenTau.balanceOf(this);
      lamdenTau.transfer(msg.sender, balance);
   }

   function issueTokens() onlyOwner  {
      
      lamdenTau.transfer(0x2D5089a716ddfb0e917ea822B2fa506A3B075997, 2160000000000000000000);
      lamdenTau.transfer(0xe195cC6e1F738Df5bB114094cE4fbd7162CaD617, 720000000000000000000);
      lamdenTau.transfer(0xfd052EC542Db2d8d179C97555434C12277a2da90, 708000000000000000000);
      lamdenTau.transfer(0xBDe659f939374ddb64Cfe05ab55a736D13DdB232, 24000000000000000000);
      lamdenTau.transfer(0x3c567089fdB2F43399f82793999Ca4e2879a1442, 96000000000000000000);
      lamdenTau.transfer(0xdDF103c148a368B34215Ac2b37892CaBC98d2eb6, 216000000000000000000);
      lamdenTau.transfer(0x32b50a36762bA0194DbbD365C69014eA63bC208A, 246000000000000000000);
      lamdenTau.transfer(0x80e264eca46565b3b89234C889f86fC48A37FD27, 420000000000000000000);
      lamdenTau.transfer(0x924fA0A32c32c98e5138526a823440846870fa11, 1260000000000000000000);
      lamdenTau.transfer(0x8899b7328114dE9e26AF0f920b933517A84d0B27, 672000000000000000000);
      lamdenTau.transfer(0x5F3034c41fE8548A0B8718622679A7A1B1d990a2, 204000000000000000000);
      lamdenTau.transfer(0xA628431d3F331Fce908249DF8589c82b5C491790, 27000000000000000000);
      lamdenTau.transfer(0xbE603e5A1d8319a656a7Bab5f98438372eeB16fC, 24000000000000000000);
      lamdenTau.transfer(0xcA71C16d3146fdd147C8bAcb878F39A4d308C7b7, 708000000000000000000);
      lamdenTau.transfer(0xe47BBeAc8F268d7126082D5574B6f027f95AF5FB, 402000000000000000000);
      lamdenTau.transfer(0xF84CDC51C1FF6487AABD352E0A5661697e0830e3, 840000000000000000000);
      lamdenTau.transfer(0xA4D826F66A65F87D60bEbfd3DcFD50d25BA51285, 552000000000000000000);
      lamdenTau.transfer(0xEFA2427A318BE3D978Aac04436A59F2649d9f7bc, 648000000000000000000);
      lamdenTau.transfer(0x850ee0810c2071205E81cf7F5A5E056736ef4567, 720000000000000000000);
      lamdenTau.transfer(0x8D7f4b8658Ae777B498C154566fBc820f88533cd, 396000000000000000000);
      lamdenTau.transfer(0xD79Cd948a969D1A4Ff01C5d3205b460b1550FF29, 12000000000000000000);
      lamdenTau.transfer(0xa3e2a6AD4b95fc293f361B2Dba448e99B286971e, 108000000000000000000);
      lamdenTau.transfer(0xf1F55c5142AC402A2b6573fb051a307f455be9bE, 720000000000000000000);
      lamdenTau.transfer(0xB95390D77F2aF27dEb09aBF9AD6A0c36Ec1333D2, 516000000000000000000);
      lamdenTau.transfer(0xb9B03611Fc1EFAdD1F1a83d84CDD8CCa5d93f0CB, 444000000000000000000);
      lamdenTau.transfer(0x1FC6523C6F8f5F4a92EF98286f75ac4Fb86709dF, 960000000000000000000);
      lamdenTau.transfer(0x0Fe8C0F024B8dF422f830c34E3c406CC05735F77, 1020000000000000000000);
      lamdenTau.transfer(0x01e6c7F612798c5C63775712F3C090F10bE120bC, 258000000000000000000);
      lamdenTau.transfer(0xf4C2D2bd0448709Fe3169e98813ff036Ae16f1a9, 2160000000000000000000);
      lamdenTau.transfer(0x5752ae7b663b57819de59945176835ff43805622, 69000000000000000000);
      uint256 balance = lamdenTau.balanceOf(this);
      lamdenTau.transfer(msg.sender, balance);
   }

}