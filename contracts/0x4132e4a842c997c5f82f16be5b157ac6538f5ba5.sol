
//Address: 0x4132e4a842c997c5f82f16be5b157ac6538f5ba5
//Contract name: Gruptecoin
//Balance: 0 Ether
//Verification Date: 8/29/2017
//Transacion Count: 1

// CODE STARTS HERE

contract Gruptecoin {
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
    function Gruptecoin () {

         initialSupply = 180000000;
        name ="Gruptecoin";
        decimals = 0;
        symbol = "GPC";
        
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
