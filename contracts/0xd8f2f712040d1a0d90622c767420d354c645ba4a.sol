
//Address: 0xd8f2f712040d1a0d90622c767420d354c645ba4a
//Contract name: BlockchainUniversityToken
//Balance: 0 Ether
//Verification Date: 2/8/2018
//Transacion Count: 3

// CODE STARTS HERE

pragma solidity ^0.4.19;
contract Token{
    uint256 public totalSupply;
    function balanceOf(address _owner) constant returns (uint256 balance);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
    function transfer(address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
contract StandardToken is Token {
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    function transfer(address _to, uint256 _value) returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) returns (bool success)   
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balances[_to] += _value;
        balances[_from] -= _value; 
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract BlockchainUniversityToken is StandardToken { 

    string public name;                   
    uint8 public decimals;               
    string public symbol;             

    function BlockchainUniversityToken() {
        balances[msg.sender] = 210000000000000000; 
        totalSupply = 210000000000000000;         
        name = "Blockchain University Token";                  
        decimals = 8;          
        symbol = "BUT";            
    }
}
