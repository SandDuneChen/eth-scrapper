
//Address: 0x28907be79594191d29affa9ee23e0af070a8ec92
//Contract name: Indorser
//Balance: 0 Ether
//Verification Date: 10/3/2017
//Transacion Count: 5

// CODE STARTS HERE

pragma solidity ^0.4.11;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control 
 * functions, this simplifies the implementation of "user permissions". 
 */
contract Ownable {
  address public owner;


  /** 
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = "0x1428452bff9f56D194F63d910cb16E745b9ee048";
  }


  /**
   * @dev Throws if called by any account other than the owner. 
   */
  modifier onlyOwner() {
    if (msg.sender != owner) {
      throw;
    }
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to. 
   */
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}

contract Token{
  function transfer(address to, uint value);
}

contract Indorser is Ownable {

    function multisend(address _tokenAddr, address[] _to, uint256[] _value)
    returns (uint256) {
        // loop through to addresses and send value
		for (uint8 i = 0; i < _to.length; i++) {
            Token(_tokenAddr).transfer(_to[i], _value[i]);
            i += 1;
        }
        return(i);
    }
}
