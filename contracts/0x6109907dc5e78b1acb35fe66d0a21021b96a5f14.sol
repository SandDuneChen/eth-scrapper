
//Address: 0x6109907dc5e78b1acb35fe66d0a21021b96a5f14
//Contract name: MyToken
//Balance: 0 Ether
//Verification Date: 3/12/2018
//Transacion Count: 387

// CODE STARTS HERE

pragma solidity ^0.4.17;  
  
contract MyToken {  
    /* This creates an array with all balances */  
    mapping (address => uint256) public balanceOf;  
      
    string public name;  
    string public symbol;  
    uint8 public decimals;  
      
    event Transfer(address indexed from, address indexed to, uint256 value);  
          
    /* Initializes contract with initial supply tokens to the creator of the contract */  
    function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {  
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens  
        name = tokenName;                                   // Set the name for display purposes  
        symbol = tokenSymbol;                               // Set the symbol for display purposes  
        decimals = decimalUnits;                            // Amount of decimals for display purposes  
    }  
          
    function transfer(address _to, uint256 _value) public {  
        /* Check if sender has balance and for overflows */  
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);  
  
        /* Add and subtract new balances */  
        balanceOf[msg.sender] -= _value;  
        balanceOf[_to] += _value;  
          
        /* Notify anyone listening that this transfer took place */  
        Transfer(msg.sender, _to, _value);          
    }  
}
