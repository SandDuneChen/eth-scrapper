
//Address: 0xfce1ebd75bef6db4e6951fb9ef7485902dbc5ae5
//Contract name: Token
//Balance: 0 Ether
//Verification Date: 12/5/2017
//Transacion Count: 5

// CODE STARTS HERE

pragma solidity ^0.4.13;
contract Token {
    
	/* Public variables of the token */
	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public totalSupply;
    
	/* This creates an array with all balances */
	mapping (address => uint256) public balanceOf;

	/* This generates a public event on the blockchain that will notify clients */
	event Transfer(address indexed from, address indexed to, uint256 value);

	function Token() {
	    totalSupply = 168*(10**6)*(10**18);
		balanceOf[msg.sender] = 168*(10**6)*(10**18);             // Give the creator all initial tokens
		name = "Oceancoin";                                   // Set the name for display purposes
		symbol = "OAC";                               // Set the symbol for display purposes
		decimals = 18;                            // Amount of decimals for display purposes
	}

	function transfer(address _to, uint256 _value) {
	/* Check if sender has balance and for overflows */
	if (balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to])
		revert();
	/* Add and subtract new balances */
	balanceOf[msg.sender] -= _value;
	balanceOf[_to] += _value;
	/* Notifiy anyone listening that this transfer took place */
	Transfer(msg.sender, _to, _value);
	}

	/* This unnamed function is called whenever someone tries to send ether to it */
	function () {
	revert();     // Prevents accidental sending of ether
	}
}