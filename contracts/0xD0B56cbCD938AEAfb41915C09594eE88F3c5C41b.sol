
//Address: 0xD0B56cbCD938AEAfb41915C09594eE88F3c5C41b
//Contract name: TRONIX
//Balance: 0 Ether
//Verification Date: 8/29/2017
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.13;
contract TRONIX {
    
	/* Public variables of the token */
	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public totalSupply;
    
	/* This creates an array with all balances */
	mapping (address => uint256) public balanceOf;

	/* This generates a public event on the blockchain that will notify clients */
	event Transfer(address indexed from, address indexed to, uint256 value);

	function TRONIX() {
	    totalSupply = 1000*(10**8)*(10**18);
		balanceOf[msg.sender] = 1000*(10**8)*(10**18);              // Give the creator all initial tokens
		name = "TRONIX";                                   // Set the name for display purposes
		symbol = "TRX";                               // Set the symbol for display purposes
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
