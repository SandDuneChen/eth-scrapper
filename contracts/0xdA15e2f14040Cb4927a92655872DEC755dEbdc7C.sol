
//Address: 0xdA15e2f14040Cb4927a92655872DEC755dEbdc7C
//Contract name: DygitalCoin
//Balance: 0 Ether
//Verification Date: 12/25/2017
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.11;   

contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
contract DygitalCoin {
    /* Public variables of the token */
    
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

  
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function DygitalCoin() {

         initialSupply = 27000000;
         name ="DygitalCoin";
         decimals = 2;
         symbol = "DGC";
        
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
