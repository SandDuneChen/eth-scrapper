
//Address: 0x3270360ede054cba2ef829af1e124c4d6e0f8a60
//Contract name: Database
//Balance: 0 Ether
//Verification Date: 5/28/2018
//Transacion Count: 4

// CODE STARTS HERE

pragma solidity ^0.4.23;

// @author: Ghilia Weldesselasie
// An experiment in using contracts as public DBs on the blockchain

contract Database {

    address public owner;

    constructor() public {
      owner = msg.sender;
    }
    
    function withdraw() public {
      require(msg.sender == owner);
      owner.transfer(address(this).balance);
    }

    // Here the 'Table' event is treated as an SQL table
    // Each property is indexed and can be retrieved easily via web3.js
    event Table(uint256 indexed _row, bytes32 indexed _column, bytes32 indexed _value);
    /*
    _______
    |||Table|||
    -----------
    | row |    _column    |    _column2   |
    |  1  |    _value     |    _value     |
    |  2  |    _value     |    _value     |
    |  3  |    _value     |    _value     |
    */

    function put(uint256 _row, string _column, string _value) public {
        emit Table(_row, keccak256(_column), keccak256(_value));
    }
}
