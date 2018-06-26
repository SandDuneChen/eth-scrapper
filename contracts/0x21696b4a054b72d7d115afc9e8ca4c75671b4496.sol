
//Address: 0x21696b4a054b72d7d115afc9e8ca4c75671b4496
//Contract name: ConsultingServices
//Balance: 0 Ether
//Verification Date: 1/22/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.18;

contract ConsultingServices {

  address public owner;
  uint256 public yearlyFee = 500 ether;
  mapping(address => Retainer) public retainers;

  //event Retained(address);

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  struct Retainer {
    uint256 startDate;
    uint256 paidFee;
  }

  function ConsultingServices() public {
    owner = msg.sender;
  }

  function changeOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
  }

  function withdraw() public onlyOwner {
    owner.transfer(this.balance);
  }

  function changeFee(uint256 _newFee) public onlyOwner {
    yearlyFee = _newFee;
  }

  function createRetainer() public payable {
    require(msg.value >= yearlyFee);
    require(retainers[msg.sender].startDate < now - 1 years);
    retainers[msg.sender] = Retainer(now, msg.value);
    //Retained(msg.sender);
  }

  function() public payable {
    createRetainer();
  }
}
