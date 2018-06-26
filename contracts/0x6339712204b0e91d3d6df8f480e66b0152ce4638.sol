
//Address: 0x6339712204b0e91d3d6df8f480e66b0152ce4638
//Contract name: EnvientaPreToken
//Balance: 0 Ether
//Verification Date: 6/10/2018
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.11;

interface token {
  function transfer( address to, uint256 value) external returns (bool ok);
  function balanceOf( address who ) external constant returns (uint256 value);
}

contract EnvientaPreToken {

  string public constant symbol = "pENV";
  string public constant name = "ENVIENTA pre-token";
  uint8 public constant decimals = 18;
  
  event Transfer(address indexed from, address indexed to, uint256 value);

  mapping( address => uint256 ) _balances;
  
  uint256 public _supply = 30000000 * 10**uint256(decimals);
  address _creator;
  token public backingToken;
  bool _buyBackMode = false;
  
  constructor() public {
    _creator = msg.sender;
    _balances[msg.sender] = _supply;
  }
  
  function totalSupply() public constant returns (uint256 supply) {
    return _supply;
  }
  
  function balanceOf( address who ) public constant returns (uint256 value) {
    return _balances[who];
  }
  
  function enableBuyBackMode(address _backingToken) public {
    require( msg.sender == _creator );
    
    backingToken = token(_backingToken);
    _buyBackMode = true;
  }
  
  function transfer( address to, uint256 value) public returns (bool ok) {
    require( _balances[msg.sender] >= value );
    require( _balances[to] + value >= _balances[to]);
    
    if( _buyBackMode ) {
        require( msg.sender != _creator );
        require( to == address(this) );
        require( backingToken.balanceOf(address(this)) >= value );
        
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer( msg.sender, to, value );
        
        backingToken.transfer(msg.sender, value);
        return true;
    } else {
        require( msg.sender == _creator );
        
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer( msg.sender, to, value );
        return true;
    }
  }
  
}
