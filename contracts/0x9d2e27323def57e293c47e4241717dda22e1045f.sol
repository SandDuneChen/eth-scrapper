
//Address: 0x9d2e27323def57e293c47e4241717dda22e1045f
//Contract name: EthereumMoon
//Balance: 0 Ether
//Verification Date: 11/28/2017
//Transacion Count: 7

// CODE STARTS HERE

pragma solidity ^0.4.18;

    contract EthereumMoon {
        string public name;
        string public symbol;
        uint8 public decimals;
        uint256 public totalSupply;
        /* This creates an array with all balances */
        mapping (address => uint256) public balanceOf;
        
        event Transfer(address indexed from, address indexed to, uint256 value);
    
    function EthereumMoon(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }

	function transfer(address _to, uint256 _value) public {
	    
	    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
	    
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
		
		        /* Notify anyone listening that this transfer took place */
        Transfer(msg.sender, _to, _value);
	}
	
}
