
//Address: 0xab5187690bbdfc9924d4eb5e13f8c9a965d60b80
//Contract name: BenToken
//Balance: 0 Ether
//Verification Date: 5/19/2018
//Transacion Count: 4

// CODE STARTS HERE

pragma solidity ^0.4.20;

contract BenToken {
    string public name="BenToken";
    string public symbol="BenCoin";
    uint8 public decimals=8;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

        /* Initializes contract with initial supply tokens to the creator of the contract */
    function constrcutor() public {
        balanceOf[msg.sender] = 10000;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
    }
}
