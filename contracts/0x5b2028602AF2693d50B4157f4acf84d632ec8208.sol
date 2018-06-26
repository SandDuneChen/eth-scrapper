
//Address: 0x5b2028602AF2693d50B4157f4acf84d632ec8208
//Contract name: Savings
//Balance: 0 Ether
//Verification Date: 10/7/2017
//Transacion Count: 6

// CODE STARTS HERE

//
// Licensed under the Apache License, version 2.0.
//
pragma solidity ^0.4.14;

contract Ownable {
    address public Owner;
    
    function Ownable() { Owner = msg.sender; }
    function isOwner() internal constant returns (bool) { return(Owner == msg.sender); }
}

contract Savings is Ownable {
    address public Owner;
    mapping (address => uint) public deposits;
    uint public openDate;
    
    event Initialized(uint OpenDate);
    event Deposit(address indexed Depositor, uint Amount);
    event Withdrawal(address indexed Withdrawer, uint Amount);
    
    function init(uint open) payable {
        Owner = msg.sender;
        openDate = open;
        Initialized(open);
    }

    function() payable { deposit(); }
    
    function deposit() payable {
        if (msg.value >= 0.5 ether) {
            deposits[msg.sender] += msg.value;
            Deposit(msg.sender, msg.value);
        }
    }
    
    function withdraw(uint amount) payable {
        if (isOwner() && now >= openDate) {
            uint max = deposits[msg.sender];
            if (amount <= max && max > 0) {
                msg.sender.transfer(amount);
                Withdrawal(msg.sender, amount);
            }
        }
    }

    function kill() payable {
        if (isOwner() && this.balance == 0) {
            selfdestruct(Owner);
        }
	}
}
