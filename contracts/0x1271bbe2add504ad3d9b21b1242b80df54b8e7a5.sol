
//Address: 0x1271bbe2add504ad3d9b21b1242b80df54b8e7a5
//Contract name: FAUT
//Balance: 0 Ether
//Verification Date: 3/12/2018
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.16;

contract FAUT {
    string public name = 'FAUT';
    string public symbol = 'FAUT';
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000000000000000000000;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function FAUT() public {
        balanceOf[msg.sender] = totalSupply; 
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

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
}
