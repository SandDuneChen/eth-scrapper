
//Address: 0x44731a7649df116b65a805d82f25bc954f97fb38
//Contract name: TheOneToken
//Balance: 0 Ether
//Verification Date: 7/26/2017
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.11;

// One Token to rule them all, One Token to find them, One Token to bring them all and in the darkness bind them
contract TheOneToken {
    string public standard = 'The One Token';
    string public name = 'The One Token';
    string public symbol = 'TOKEN';
    
    uint8 public decimals = 0;
    uint256 public totalSupply = 1;
    mapping (address => uint256) public balanceOf;
    
    address public owner;
    address public tokenBearer;
    
    uint public lastStealValue;
    
    event Passed(address from, address to);

    // The One Token constructor
    function TheOneToken() {
        owner = msg.sender;
        passToken(owner);
        lastStealValue = 0;
    }
    
    // Internal to pass Token
    function passToken(address _to) internal {
        Passed(tokenBearer, _to);
        
        balanceOf[tokenBearer] = 0;
        
        tokenBearer = _to;
        balanceOf[tokenBearer] = 1;
    }
    
    // It came to me. It's mine, my own, my love, my precious.
    // # Send more than the last steal value to steal token
    function () payable {
        require(msg.value > lastStealValue);
        lastStealValue = msg.value;
        passToken(msg.sender);
    }
    
    // One does not simply walk into Mordor..
    function tossIntoTheFire() {
        require(msg.sender == tokenBearer);
        require(block.number > 5800000);
        
        // Are you sure you want to destroy it?
        suicide(owner);
    }

    // Even the smallest person can change the course of the future.
    function transfer(address _to) {
        require(msg.sender == tokenBearer);
        passToken(_to);
    }
}
