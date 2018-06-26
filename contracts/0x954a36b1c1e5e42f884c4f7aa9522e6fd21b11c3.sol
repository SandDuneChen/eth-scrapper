
//Address: 0x954a36b1c1e5e42f884c4f7aa9522e6fd21b11c3
//Contract name: Vault
//Balance: 0 Ether
//Verification Date: 10/8/2017
//Transacion Count: 15

// CODE STARTS HERE

pragma solidity ^0.4.10;

contract Vault {
    
    event Deposit(address indexed depositor, uint amount);
    event Withdrawal(address indexed to, uint amount);
    
    address Owner;
    
    mapping (address => uint) public deposits;
    uint Date;
    uint MinimumDeposit;
    bool Locked = false;
    
    function initVault(uint minDeposit) isOpen payable {
        Owner = msg.sender;
        Date = 0;
        MinimumDeposit = minDeposit;
        deposit();
    }

    function() payable { deposit(); }

    function SetLockDate(uint NewDate) onlyOwner {
        Date = NewDate;
    }

    function WithdrawalEnabled() constant returns (bool) { return Date > 0 && Date <= now; }

    function deposit() payable {
        if (msg.value >= MinimumDeposit) {
            if ((deposits[msg.sender] + msg.value) < deposits[msg.sender]) {
                return;
            }
            deposits[msg.sender] += msg.value;
        }
        Deposit(msg.sender, msg.value);
    }

    function withdraw(address to, uint amount) onlyOwner {
        if (WithdrawalEnabled()) {
            if (amount <= this.balance) {
                to.transfer(amount);
            }
        }
    }

    modifier onlyOwner { if (msg.sender == Owner) _; }
    modifier isOpen { if (!Locked) _; }
    function lock() { Locked = true; }
}
