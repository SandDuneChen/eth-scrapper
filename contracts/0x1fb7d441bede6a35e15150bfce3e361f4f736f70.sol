
//Address: 0x1fb7d441bede6a35e15150bfce3e361f4f736f70
//Contract name: EREEBERRY
//Balance: 0 Ether
//Verification Date: 7/9/2017
//Transacion Count: 2

// CODE STARTS HERE

contract EREEBERRY {
    /* Public variables of the token */
    string public standard = 'Token 0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

  
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function EREEBERRY() {

         initialSupply = 1000000;
         name ="EREEBERRY";
        decimals = 0;
         symbol = "EB";
        
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        uint256 totalSupply = initialSupply;                        // Update total supply
                                   
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
