
//Address: 0xb7937873dfe37fda7a51939f220e0130379f0095
//Contract name: DokitaCoin
//Balance: 0 Ether
//Verification Date: 7/27/2017
//Transacion Count: 1

// CODE STARTS HERE

contract DokitaCoin {
    /* Public variables of the token */
    string public standard = 'DokitaCoin';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

  
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function Token() {

         initialSupply = 100000000;
         name ="DokitaCoin";
        decimals = 18;
         symbol = "DOKI";
        
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
