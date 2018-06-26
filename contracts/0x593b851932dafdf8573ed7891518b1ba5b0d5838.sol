
//Address: 0x593b851932dafdf8573ed7891518b1ba5b0d5838
//Contract name: TheDapp
//Balance: 0.05 Ether
//Verification Date: 9/29/2017
//Transacion Count: 6

// CODE STARTS HERE

pragma solidity ^0.4.17;

contract TheDapp {

  string public message;
  address public owner;
  uint256 public fee;

  event OnUpdateMessage();
  event OnUpdateFee();

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function TheDapp(uint256 _fee) public {
    owner = msg.sender;
    fee = (_fee * 1 finney);
  }

  function setMessage(string _message) public payable {
    require(msg.value == fee);
    message = _message;
    OnUpdateMessage();
  }
  
  function setFee(uint256 _fee) public onlyOwner {
    fee = (_fee * 1 finney);
    OnUpdateFee();
  }

  function withdraw(address addr) public onlyOwner {
    addr.transfer(this.balance);
  }

  function kill() public onlyOwner {
    selfdestruct(owner);
  }
}
