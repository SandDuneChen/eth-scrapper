
//Address: 0x470b0b2415adbe31fced8434d7b031bb7ede7f54
//Contract name: ZENT
//Balance: 0 Ether
//Verification Date: 3/9/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.4;

contract ZENT {
    /* Public variables of the token */
    string public standard = 'Token 0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;


    /* Initializes contract with initial supply tokens to the creator of the contract */
    function ZENT() {

         initialSupply = 1000000000;
         name ="ZENT";
        decimals = 0;
         symbol = "ZENT";

        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        totalSupply = initialSupply;                        // Update total supply

    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient

    }







    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }
}
