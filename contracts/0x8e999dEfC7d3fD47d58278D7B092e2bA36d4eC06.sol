
//Address: 0x8e999dEfC7d3fD47d58278D7B092e2bA36d4eC06
//Contract name: KYC
//Balance: 0 Ether
//Verification Date: 1/29/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.18;

contract Owned {
  address public Owner;
  
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Owned() public {
    Owner = msg.sender;
  }

  modifier OnlyOwner() {
    require(msg.sender == Owner);
    _;
  }

  function transferOwnership(address newOwner) public OnlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(Owner, newOwner);
    Owner = newOwner;
  }
}

contract KYC is Owned {
  mapping (address => mapping (bool => bool)) public RegisteredAddress;

  mapping (address => bool) public admin;

  event Registered(address indexed _addr);
  event Unregistered(address indexed _addr);
  event SetAdmin(address indexed _addr);

  modifier KYCRegistered(address _addr, bool _isPresale) {
    require(RegisteredAddress[_addr][_isPresale]);
    _;
  }

  modifier OnlyAdmin() {
    require(admin[msg.sender]);
    _;
  }

  function KYC() public {
    admin[msg.sender] = true;
  }

  function setAdmin(address _addr, bool _value)
    public
    OnlyOwner
    returns (bool) {
    require(_addr != address(0));
    require(admin[_addr] == !_value);

    admin[_addr] = _value;

    SetAdmin(_addr);

    return true;
  }

  function isRegistered(address _addr, bool _isPresale)
    public
    view
    returns (bool) {
    return RegisteredAddress[_addr][_isPresale];
  }

  function register(address _addr, bool _isPresale)
    public
    OnlyAdmin {
    require(_addr != address(0) && RegisteredAddress[_addr][_isPresale] == false);

    RegisteredAddress[_addr][_isPresale] = true;

    Registered(_addr);
  }

  function RegisterList(address[] _addrs, bool _isPresale)
    public
    OnlyAdmin {
    for(uint256 i = 0; i < _addrs.length; i++) {
      register(_addrs[i], _isPresale);
    }
  }

  function Unregister(address _addr, bool _isPresale)
    public
    OnlyAdmin
    KYCRegistered(_addr, _isPresale) {
    RegisteredAddress[_addr][_isPresale] = false;

    Unregistered(_addr);
  }

  function UnregisterList(address[] _addrs, bool _isPresale)
    public
    OnlyAdmin {
    for(uint256 i = 0; i < _addrs.length; i++) {
      Unregister(_addrs[i], _isPresale);
    }
  }
}