
//Address: 0x3bbb50a8979443dbaab05da1264ef2f1f1b1a3f6
//Contract name: INDISafe
//Balance: 0 Ether
//Verification Date: 1/25/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.18;
contract Token {
    uint256 public totalSupply;
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


/*  ERC 20 token */
contract StandardToken is Token {

    function transfer(address _to, uint256 _value) returns (bool success) {
      if (balances[msg.sender] >= _value && _value > 0) {
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
      } else {
        return false;
      }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
      } else {
        return false;
      }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}
// requires 200,000,000 INDI deposited here for Social Vault
contract INDISafe {
  mapping (address => uint256) allocations;
  uint256 public unlockDate;
  address public INDI;
  uint256 public constant exponent = 10**18;

  function INDISafe() {
    INDI = 0xe8c09672cfb9cfce6e2edbb01057d9fa569f97c1;
    unlockDate = 1518134400;
    allocations[0x91c594706246Bed9a99CB49718b95D0F067042C8] = 200000000; 
    
  }

  function unlock() external {
    if(now < unlockDate) revert();
    uint256 entitled = allocations[msg.sender];
    allocations[msg.sender] = 0;
    if(!StandardToken(INDI).transfer(msg.sender, entitled * exponent)) revert();
  }

}
