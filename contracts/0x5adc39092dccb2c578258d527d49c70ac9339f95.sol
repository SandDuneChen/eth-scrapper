
//Address: 0x5adc39092dccb2c578258d527d49c70ac9339f95
//Contract name: TOPB
//Balance: 0 Ether
//Verification Date: 5/30/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.19;

contract TOPB {
    string public name = 'TOPBTC PLATFORM TOKEN';
    string public symbol = 'TOPB';
    uint8 public decimals = 18;
    uint256 public supply;
	
    mapping (address => uint256) public balanceOf;
	
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
	
    function () payable public {
		assert(false);
    }

    function TOPB() public {
        supply = 200000000 * 10 ** uint256(decimals);
        balanceOf[msg.sender] = supply;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
		assert(_to != 0x0);
		assert(balanceOf[_from] >= _value);
		assert(balanceOf[_to] + _value > balanceOf[_to]);
		uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;
		Transfer(_from, _to, _value);
		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function burn(uint256 _value) public returns (bool success) {
        assert(balanceOf[msg.sender] >= _value); 
        balanceOf[msg.sender] -= _value;
        supply -= _value;
        Burn(msg.sender, _value);
        return true;
    }
}
