
//Address: 0xc7787c3b001284d712d86d60e247ab7bb25806c7
//Contract name: Error
//Balance: 0 Ether
//Verification Date: 3/15/2018
//Transacion Count: 1

// CODE STARTS HERE

contract Error {
  
    string public standard = '0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

  
    
    function Error() {

         initialSupply = 1000000000;
         name ="Error";
        decimals = 1;
         symbol = "404";
        
        balanceOf[msg.sender] = initialSupply;              
        totalSupply = initialSupply;                        
                                   
    }

    
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
        balanceOf[msg.sender] -= _value;                     
        balanceOf[_to] += _value;                            
      
    }

   

    

   

    
    function () {
        throw;    
    }
}
