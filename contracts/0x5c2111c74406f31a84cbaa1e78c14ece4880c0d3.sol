
//Address: 0x5c2111c74406f31a84cbaa1e78c14ece4880c0d3
//Contract name: FUTokenContract
//Balance: 0 Ether
//Verification Date: 5/20/2018
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.20;

contract FUTokenContract {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

        /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        require(_to != 0x0);                                // Prevent transfer to 0x0 address.
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
    }
}
