
//Address: 0x74a0c6112ac7d03015403bcbe3bc09a501eeb31b
//Contract name: ymtest
//Balance: 0 Ether
//Verification Date: 5/22/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.16;


contract ymtest{
    string public name;
    string public symbol;
    uint8 public decimals = 8; 
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    event Transfer(address indexed from, address indexed to, uint256 value);

    function ymtest(uint256 abc) public {
        totalSupply = 1000000000 * 10 ** uint256(decimals);  
        balanceOf[msg.sender] = totalSupply;                
        name = "ymtest";                                  
        symbol = "ymtest";                              
    }

  
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }


    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
	
}
