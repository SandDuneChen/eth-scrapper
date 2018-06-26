
//Address: 0xe2dcd10f43cd9229f253e5147a793e6f64283f2b
//Contract name: DayDayToken
//Balance: 0 Ether
//Verification Date: 3/25/2018
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.19;
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}
/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    /// Total amount of tokens
  uint256 public totalSupply;
  
  function balanceOf(address _owner) public view returns (uint256 balance);
  
  function transfer(address _to, uint256 _amount) public returns (bool success);
  
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender) public view returns (uint256 remaining);
  
  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
  
  function approve(address _spender, uint256 _amount) public returns (bool success);
  
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  //balance in each address account
  mapping(address => uint256) balances;
  address ownerWallet;
  struct Lockup
  {
      uint256 lockupTime;
      uint256 lockupAmount;
  }
  Lockup lockup;
  mapping(address=>Lockup) lockupParticipants;  
  
  
  uint256 startTime;
  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _amount The amount to be transferred.
  */
  function transfer(address _to, uint256 _amount) public returns (bool success) {
    require(_to != address(0));
    require(balances[msg.sender] >= _amount && _amount > 0
        && balances[_to].add(_amount) > balances[_to]);

    if (lockupParticipants[msg.sender].lockupAmount>0)
    {
        uint timePassed = now - startTime;
        if (timePassed < lockupParticipants[msg.sender].lockupTime)
        {
            require(balances[msg.sender].sub(_amount) >= lockupParticipants[msg.sender].lockupAmount);
        }
    }
    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Transfer(msg.sender, _to, _amount);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 */
contract StandardToken is ERC20, BasicToken {
  
  
  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _amount uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
    require(_to != address(0));
    require(balances[_from] >= _amount);
    require(allowed[_from][msg.sender] >= _amount);
    require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
    
    if (lockupParticipants[_from].lockupAmount>0)
    {
        uint timePassed = now - startTime;
        if (timePassed < lockupParticipants[_from].lockupTime)
        {
            require(balances[msg.sender].sub(_amount) >= lockupParticipants[_from].lockupAmount);
        }
    }
    balances[_from] = balances[_from].sub(_amount);
    balances[_to] = balances[_to].add(_amount);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
    emit Transfer(_from, _to, _amount);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _amount The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _amount) public returns (bool success) {
    allowed[msg.sender][_spender] = _amount;
    emit Approval(msg.sender, _spender, _amount);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

}

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is StandardToken, Ownable {

    event Burn(address indexed burner, uint256 value);

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public onlyOwner{
        require(_value <= balances[ownerWallet]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        balances[ownerWallet] = balances[ownerWallet].sub(_value);
        totalSupply = totalSupply.sub(_value);
        emit Burn(msg.sender, _value);
    }
}
/**
 * @title DayDay Token
 * @dev Token representing DD.
 */
 contract DayDayToken is BurnableToken {
     string public name ;
     string public symbol ;
     uint8 public decimals =  2;
     
   
     /**
     *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
     */
     function ()public payable {
         revert();
     }
     
     /**
     * @dev Constructor function to initialize the initial supply of token to the creator of the contract
     */
     function DayDayToken(address wallet) public 
     {
         owner = msg.sender;
         ownerWallet = wallet;
         totalSupply = 300000000000;
         totalSupply = totalSupply.mul(10 ** uint256(decimals)); //Update total supply with the decimal amount
         name = "DayDayToken";
         symbol = "DD";
         balances[wallet] = totalSupply;
         startTime = now;
         
         //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
         emit Transfer(address(0), msg.sender, totalSupply);
     }
     
     /**
     *@dev helper method to get token details, name, symbol and totalSupply in one go
     */
    function getTokenDetail() public view returns (string, string, uint256) {
	    return (name, symbol, totalSupply);
    }
    
     
    function lockTokensForFs (address F1, address F2) public onlyOwner
    {
        lockup = Lockup({lockupTime:720 days,lockupAmount:90000000 * 10 ** uint256(decimals)});
        lockupParticipants[F1] = lockup;
        
        lockup = Lockup({lockupTime:720 days,lockupAmount:60000000 * 10 ** uint256(decimals)});
        lockupParticipants[F2] = lockup;
    }
    function lockTokensForAs( address A1, address A2, 
                         address A3, address A4,
                         address A5, address A6,
                         address A7, address A8,
                         address A9) public onlyOwner
    {
        lockup = Lockup({lockupTime:180 days,lockupAmount:90000000 * 10 ** uint256(decimals)});
        lockupParticipants[A1] = lockup;
        
        lockup = Lockup({lockupTime:180 days,lockupAmount:60000000 * 10 ** uint256(decimals)});
        lockupParticipants[A2] = lockup;
        
        lockup = Lockup({lockupTime:180 days,lockupAmount:30000000 * 10 ** uint256(decimals)});
        lockupParticipants[A3] = lockup;
        
        lockup = Lockup({lockupTime:180 days,lockupAmount:60000000 * 10 ** uint256(decimals)});
        lockupParticipants[A4] = lockup;
        
        lockup = Lockup({lockupTime:180 days,lockupAmount:60000000 * 10 ** uint256(decimals)});
        lockupParticipants[A5] = lockup;
        
        lockup = Lockup({lockupTime:180 days,lockupAmount:15000000 * 10 ** uint256(decimals)});
        lockupParticipants[A6] = lockup;
        
        lockup = Lockup({lockupTime:180 days,lockupAmount:15000000 * 10 ** uint256(decimals)});
        lockupParticipants[A7] = lockup;
        
        lockup = Lockup({lockupTime:180 days,lockupAmount:15000000 * 10 ** uint256(decimals)});
        lockupParticipants[A8] = lockup;
        
        lockup = Lockup({lockupTime:180 days,lockupAmount:15000000 * 10 ** uint256(decimals)});
        lockupParticipants[A9] = lockup;
    }
    
    function lockTokensForCs(address C1,address C2, address C3) public onlyOwner
    {
        lockup = Lockup({lockupTime:90 days,lockupAmount:2500000 * 10 ** uint256(decimals)});
        lockupParticipants[C1] = lockup;
        
        lockup = Lockup({lockupTime:90 days,lockupAmount:1000000 * 10 ** uint256(decimals)});
        lockupParticipants[C2] = lockup;
        
        lockup = Lockup({lockupTime:90 days,lockupAmount:1500000 * 10 ** uint256(decimals)});
        lockupParticipants[C3] = lockup;   
    }
    
    function lockTokensForTeamAndReserve(address team) public onlyOwner
    {
        lockup = Lockup({lockupTime:360 days,lockupAmount:63000000 * 10 ** uint256(decimals)});
        lockupParticipants[team] = lockup;
        
        lockup = Lockup({lockupTime:720 days,lockupAmount:415000000 * 10 ** uint256(decimals)});
        lockupParticipants[ownerWallet] = lockup;
    }
 }
