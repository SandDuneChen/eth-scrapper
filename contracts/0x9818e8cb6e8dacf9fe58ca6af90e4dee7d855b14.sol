
//Address: 0x9818e8cb6e8dacf9fe58ca6af90e4dee7d855b14
//Contract name: REOC
//Balance: 0 Ether
//Verification Date: 4/10/2018
//Transacion Count: 7

// CODE STARTS HERE

pragma solidity ^0.4.4;

contract REOC {
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
    function REOC() {

         initialSupply = 200000000;
         name ="Recycled Oil Coin";
        decimals = 2;
         symbol = "REOC";
        
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
