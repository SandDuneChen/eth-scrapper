
//Address: 0x5a41cdade9ad98a3d09589cfebd147a25a8e7e29
//Contract name: NESTLE_301201
//Balance: 0 Ether
//Verification Date: 5/2/2018
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity 		^0.4.21	;						
									
contract	NESTLE_301201				{				
									
	mapping (address => uint256) public balanceOf;								
									
	string	public		name =	"	NESTLE_301201		"	;
	string	public		symbol =	"	NESTI		"	;
	uint8	public		decimals =		18			;
									
	uint256 public totalSupply =		10813876628517800000000000					;	
									
	event Transfer(address indexed from, address indexed to, uint256 value);								
									
	function SimpleERC20Token() public {								
		balanceOf[msg.sender] = totalSupply;							
		emit Transfer(address(0), msg.sender, totalSupply);							
	}								
									
	function transfer(address to, uint256 value) public returns (bool success) {								
		require(balanceOf[msg.sender] >= value);							
									
		balanceOf[msg.sender] -= value;  // deduct from sender's balance							
		balanceOf[to] += value;          // add to recipient's balance							
		emit Transfer(msg.sender, to, value);							
		return true;							
	}								
									
	event Approval(address indexed owner, address indexed spender, uint256 value);								
									
	mapping(address => mapping(address => uint256)) public allowance;								
									
	function approve(address spender, uint256 value)								
		public							
		returns (bool success)							
	{								
		allowance[msg.sender][spender] = value;							
		emit Approval(msg.sender, spender, value);							
		return true;							
	}								
									
	function transferFrom(address from, address to, uint256 value)								
		public							
		returns (bool success)							
	{								
		require(value <= balanceOf[from]);							
		require(value <= allowance[from][msg.sender]);							
									
		balanceOf[from] -= value;							
		balanceOf[to] += value;							
		allowance[from][msg.sender] -= value;							
		emit Transfer(from, to, value);							
		return true;							
	}								
}
