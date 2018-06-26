
//Address: 0x5c591aaa5b18d6411b01c9e6862b155f0433a6c2
//Contract name: PiaoPiaoToken
//Balance: 0 Ether
//Verification Date: 5/29/2018
//Transacion Count: 4

// CODE STARTS HERE

pragma solidity ^0.4.24;
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

contract LoveToken is Ownable{
    uint256 public totalSupply;
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}

contract PiaoPiaoToken is LoveToken {
    mapping (address => uint256) balances;
    string public name;                   
    uint8 public decimals;               
    string public symbol;
    string public loveUrl;
    
    function PiaoPiaoToken() {
        balances[msg.sender] = 5201314; 
        totalSupply = 5201314;         
        name = "PiaoPiao Token";                   
        decimals = 0;          
        symbol = "PPT";  
    }
    
    function setLoveUrl(string _loveUrl) onlyOwner public returns (bool success) {
        loveUrl = _loveUrl;
        return true;
    }
    
    function transfer(address _to, uint256 _value) returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
}
