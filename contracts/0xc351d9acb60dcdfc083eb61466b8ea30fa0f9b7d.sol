
//Address: 0xc351d9acb60dcdfc083eb61466b8ea30fa0f9b7d
//Contract name: AccessList
//Balance: 0 Ether
//Verification Date: 4/9/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.20;

contract AccessList {
    event Added(address _user);
    event Removed(address _user);

    mapping(address => bool) public access;

    function isSet(address addr) external view returns(bool) {
        return access[addr];
    }

    function add() external {
        require(!access[msg.sender]);
        access[msg.sender] = true;
        emit Added(msg.sender);
    }

    function remove() external {
        require(access[msg.sender]);
        access[msg.sender] = false;
        emit Removed(msg.sender);
    }
}
