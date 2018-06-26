
//Address: 0x452a72e290feeeb08ff80a08acdac2267cc29c06
//Contract name: Parameters
//Balance: 0 Ether
//Verification Date: 11/15/2017
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.15;



contract IPFSEvents {
  event HashAdded(address PubKey, string IPFSHash, uint ttl);
  event HashRemoved(address PubKey, string IPFSHash);
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}


contract Parameters is IPFSEvents,Ownable {
  mapping (string => string) parameters;

  event ParameterSet(string name, string value);
  uint defaultTTL;

  function Parameters(uint _defaultTTL) public {
    defaultTTL = _defaultTTL;
  }

  function setTTL(uint _ttl) onlyOwner public {
    defaultTTL = _ttl;
  }

  function setParameter(string _name, string _value) onlyOwner public {
    ParameterSet(_name,_value);
    parameters[_name] = _value;
  }

  function setIPFSParameter(string _name, string _ipfsValue) onlyOwner public {
    setParameter(_name,_ipfsValue);
    HashAdded(this,_ipfsValue,defaultTTL);
  }

  function getParameter(string _name) public constant returns (string){
    return parameters[_name];
  }

}
