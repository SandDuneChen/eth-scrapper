
//Address: 0xeF81796941E13116b087A35C0602Aa4e3A82C5cc
//Contract name: CyberToken
//Balance: 0 Ether
//Verification Date: 8/27/2017
//Transacion Count: 7

// CODE STARTS HERE

pragma solidity ^0.4.10;

contract CyberToken
{

	string public name; 
	string public symbol; 
	uint8 public decimals; 
	uint256 public totalSupply;


	mapping (address => uint256) public balanceOf;


	event Transfer(address indexed from, address indexed to, uint256 value);
	event Burn(address indexed from, uint256 value);


	function CyberToken() 
	{
		name = "CyberToken";
		symbol = "CYB";
		decimals = 12;
		totalSupply = 625000000000000000000;
		balanceOf[msg.sender] = totalSupply;
	}


	function transfer(address _to, uint256 _value) 
	{ 
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
		Transfer(msg.sender, _to, _value); 
	}


	function burn(address _from, uint256 _value) returns (bool success)
	{
		if (balanceOf[msg.sender] < _value) throw;
		balanceOf[_from] -= _value;
		totalSupply -= _value;
		Burn(_from, _value);
		return true;
	}
}
