
//Address: 0x186a302605e4f03da2fb8750ce75ee488b971c8a
//Contract name: COSHAHKD
//Balance: 0 Ether
//Verification Date: 2/19/2018
//Transacion Count: 4

// CODE STARTS HERE

contract COSHAHKD {
    string public standard = 'CHKD 2.0';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

  
    function COSHAHKD() {

         initialSupply = 100000000000000;
         name ="COSHAHKD";
         decimals = 4;
         symbol = "CHKD";
        
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
