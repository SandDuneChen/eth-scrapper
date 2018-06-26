
//Address: 0x7c8db6eefa66f5fca3343bd10f7d4932b0c152f7
//Contract name: GigsToken
//Balance: 0 Ether
//Verification Date: 10/24/2017
//Transacion Count: 5

// CODE STARTS HERE

pragma solidity ^0.4.16;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
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

contract GigsToken {
    
    using SafeMath for uint256;
    
    /**For unlimited supply set _totalSupply to 0, delete the word "constant", 
     *and uncomment "_totalSupply" in createTokens()
     */
    uint public constant _totalSupply = 16000000; 
    
    string public constant symbol = "GIX";
    string public constant name = "Blockchain Gigs";
    uint8 public constant decimals = 18;
	uint256 public constant totalSupply = _totalSupply * 10 ** uint256(decimals);
    
    // 1 ether = 500 gigs
    uint256 public constant RATE = 500;
    
    address public owner; 
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    
    function () public payable {
        createTokens();
    }
    
    function GigsToken() public {
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }
    
    function createTokens() public payable {
        require(msg.value > 0);
        uint256 tokens = msg.value.mul(RATE);
        balances[msg.sender] = balances[msg.sender].add(tokens);
        
        //_totalSupply = _totalSupply.add(tokens);
        
        owner.transfer(msg.value);
    }
    
    function balanceOf(address _owner) internal view returns (uint256 balance){
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(allowed [_from][msg.sender] >= 0 && balances[_from] >= _value && _value > 0);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
        
    }
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) constant public returns (uint256 remaining){
        return allowed[_owner][_spender];
    }
    

}
