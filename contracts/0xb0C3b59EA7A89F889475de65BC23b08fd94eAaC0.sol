
//Address: 0xb0C3b59EA7A89F889475de65BC23b08fd94eAaC0
//Contract name: Migrations
//Balance: 0 Ether
//Verification Date: 11/22/2017
//Transacion Count: 9

// CODE STARTS HERE

pragma solidity ^0.4.4;

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
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}

contract Migrations is Ownable {
    uint public last_completed_migration;

    function setCompleted(uint _completed) onlyOwner {
        last_completed_migration = _completed;
    }

    function upgrade(address _newAddress) onlyOwner {
        Migrations upgraded = Migrations(_newAddress);
        upgraded.setCompleted(last_completed_migration);
    }
}
