
//Address: 0x39142a73f414cb94b4baae892c75d5a828cd4230
//Contract name: Crowdsale
//Balance: 0 Ether
//Verification Date: 2/19/2018
//Transacion Count: 17

// CODE STARTS HERE

pragma solidity ^0.4.18;

/// @title Ownable
/// @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies
/// & the implementation of "user permissions".

contract Ownable {
    address public owner;
    address public newOwnerCandidate;

    event OwnershipRequested(address indexed _by, address indexed _to);
    event OwnershipTransferred(address indexed _from, address indexed _to);

    /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
    function Ownable() {
        owner = msg.sender;
    }

    /// @dev Throws if called by any account other than the owner.
    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }

        _;
    }

    /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
    /// @param _newOwnerCandidate address The address to transfer ownership to.
    function transferOwnership(address _newOwnerCandidate) onlyOwner {
        require(_newOwnerCandidate != address(0));

        newOwnerCandidate = _newOwnerCandidate;

        OwnershipRequested(msg.sender, newOwnerCandidate);
    }

    /// @dev Accept ownership transfer. This method needs to be called by the perviously proposed owner.
    function acceptOwnership() {
        if (msg.sender == newOwnerCandidate) {
            owner = newOwnerCandidate;
            newOwnerCandidate = address(0);

            OwnershipTransferred(owner, newOwnerCandidate);
        }
    }
}

interface token {
    function transfer(address _to, uint256 _amount);
}
 
contract Crowdsale is Ownable {
    
    address public beneficiary = msg.sender;
    token public epm;
    
    uint256 public constant EXCHANGE_RATE = 25000; // 25000 EPM for ETH
    uint256 public constant DURATION = 71 days;
    uint256 public startTime = 0;
    uint256 public endTime = 0;
    
    uint public amount = 0;

    mapping(address => uint256) public balanceOf;
    
    event FundTransfer(address backer, uint amount, bool isContribution);

    /**
     * Constructor function
     *
     */
     
    function Crowdsale() {
        epm = token(0xc5594d84B996A68326d89FB35E4B89b3323ef37d);
        startTime = now;
        endTime = startTime + DURATION;
    }

    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */
     
    function () payable onlyDuringSale() {
        uint SenderAmount = msg.value;
        balanceOf[msg.sender] += SenderAmount;
        amount = amount + SenderAmount;
        epm.transfer(msg.sender, SenderAmount * EXCHANGE_RATE);
        FundTransfer(msg.sender,  SenderAmount * EXCHANGE_RATE, true);
    }

 /// @dev Throws if called when not during sale.
    modifier onlyDuringSale() {
        if (now < startTime || now >= endTime) {
            throw;
        }

        _;
    }
    
    function Withdrawal() onlyOwner {
            if (amount > 0) {
                    if (beneficiary.send(amount)) {
                        FundTransfer(msg.sender, amount, false);
                        amount = 0;
                    } else {
                        balanceOf[beneficiary] = amount;
                }
            }

    }
}