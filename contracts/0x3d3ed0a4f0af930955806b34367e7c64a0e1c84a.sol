
//Address: 0x3d3ed0a4f0af930955806b34367e7c64a0e1c84a
//Contract name: ASStokenICO
//Balance: 0 Ether
//Verification Date: 8/4/2017
//Transacion Count: 223

// CODE STARTS HERE

pragma solidity ^0.4.11;

/**
* @author Jefferson Davis
* ASStoken_ICO.sol creates the client's token for crowdsale and allocates an equity portion to the owner
*   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea
*   Additional crowdsale contracts, functions, libraries from OpenZeppelin
*       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
*   Token contract edited from original contract code at https://www.ethereum.org/token
*   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens
**/

contract ERC20 {
	//Sets events and functions for ERC20 token
	event Approval(address indexed _owner, address indexed _spender, uint _value);
	event Transfer(address indexed _from, address indexed _to, uint _value);
	
    function allowance(address _owner, address _spender) constant returns (uint remaining);
	function approve(address _spender, uint _value) returns (bool success);
    function balanceOf(address _owner) constant returns (uint balance);
    function transfer(address _to, uint _value) returns (bool success);
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
}


contract Owned {
	//Public variable
    address public owner;

	//Sets contract creator as the owner
    function Owned() {
        owner = msg.sender;
    }
	
	//Sets onlyOwner modifier for specified functions
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

	//Allows for transfer of contract ownership
    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}


library SafeMath {
    function add(uint256 a, uint256 b) internal returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }  

    function div(uint256 a, uint256 b) internal returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function max64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a >= b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a < b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a < b ? a : b;
    }
  
    function mul(uint256 a, uint256 b) internal returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function sub(uint256 a, uint256 b) internal returns (uint256) {
        assert(b <= a);
        return a - b;
    }
}


contract ASStoken is ERC20, Owned {
    //Applies SafeMath library to uint256 operations 
    using SafeMath for uint256;

	//Public variables
	string public name; 
	string public symbol; 
	uint256 public decimals;  
    uint256 public initialSupply; 
	uint256 public totalSupply; 

    //Variables
    uint256 multiplier; 
	
	//Creates arrays for balances
    mapping (address => uint256) balance;
    mapping (address => mapping (address => uint256)) allowed;

    //Creates modifier to prevent short address attack
    modifier onlyPayloadSize(uint size) {
        if(msg.data.length < size + 4) revert();
        _;
    }

	//Constructor
	function ASStoken(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier, uint256 initialAmount) {
		name = tokenName; 
		symbol = tokenSymbol; 
		decimals = decimalUnits; 
        multiplier = decimalMultiplier; 
        initialSupply = initialAmount; 
		totalSupply = initialSupply;  
	}
	
	//Provides the remaining balance of approved tokens from function approve 
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

	//Allows for a certain amount of tokens to be spent on behalf of the account owner
    function approve(address _spender, uint256 _value) returns (bool success) { 
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

	//Returns the account balance 
    function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
        return balance[_owner];
    }

    //Allows contract owner to mint new tokens, prevents numerical overflow
	function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
		require(mintedAmount > 0); 
        uint256 addTokens = mintedAmount; 
		balance[target] += addTokens;
		totalSupply += addTokens;
		Transfer(0, target, addTokens);
		return true; 
	}

	//Sends tokens from sender's account
    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
        if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
            balance[msg.sender] -= _value;
            balance[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { 
			return false; 
		}
    }
	
	//Transfers tokens from an approved account 
    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
        if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
            balance[_to] += _value;
            balance[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { 
			return false; 
		}
    }
}


contract ASStokenICO is Owned, ASStoken {
    //Applies SafeMath library to uint256 operations 
    using SafeMath for uint256;

    //Public Variables
    address public multiSigWallet;                  
    uint256 public amountRaised; 
    uint256 public deadline; 
    uint256 public hardcap; 
    uint256 public price;                            

    //Variables
    bool crowdsaleClosed = true;                    
    string tokenName = "ASStoken"; 
    string tokenSymbol = "ASS"; 
    uint256 initialTokens = 150000000000; 
    uint256 multiplier = 10000; 
    uint8 decimalUnits = 4;  

    

   	//Initializes the token
	function ASStokenICO(address beneficiaryAccount) 
    	ASStoken(tokenName, tokenSymbol, decimalUnits, multiplier, initialTokens) {
            balance[msg.sender] = initialTokens;     
            Transfer(0, msg.sender, initialTokens);    
            multiSigWallet = beneficiaryAccount;        
            hardcap = 55000000;    
            hardcap = hardcap.mul(multiplier); 
            setPrice(40000); 
    }

    //Fallback function creates tokens and sends to investor when crowdsale is open
    function () payable {
        require(!crowdsaleClosed 
            && (now < deadline) 
            && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap)); 
        address recipient = msg.sender; 
        amountRaised = amountRaised.add(msg.value.div(1 ether)); 
        uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);
        totalSupply = totalSupply.add(tokens);
        balance[recipient] = balance[recipient].add(tokens);
        require(multiSigWallet.send(msg.value)); 
        Transfer(0, recipient, tokens);
    }   

    //Returns the current price of the token for the crowdsale
    function getPrice() returns (uint256 result) {
        return price;
    }

    //Sets the multisig wallet for a crowdsale
    function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {
        multiSigWallet = wallet; 
        return true; 
    }

    //Sets the token price 
    function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {
        require(newPriceperEther > 0); 
        price = newPriceperEther; 
        return price; 
    }

    //Allows owner to start the crowdsale from the time of execution until a specified deadline
    function startSale(uint256 lengthOfSale) onlyOwner returns (bool success) {
        deadline = now + lengthOfSale * 1 days; 
        crowdsaleClosed = false; 
        return true; 
    }

    //Allows owner to stop the crowdsale immediately
    function stopSale() onlyOwner returns (bool success) {
        deadline = now; 
        crowdsaleClosed = true;
        return true; 
    }
}
