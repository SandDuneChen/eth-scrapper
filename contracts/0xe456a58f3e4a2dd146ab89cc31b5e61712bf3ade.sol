
//Address: 0xe456a58f3e4a2dd146ab89cc31b5e61712bf3ade
//Contract name: SafeMath
//Balance: 0 Ether
//Verification Date: 2/10/2018
//Transacion Count: 1

// CODE STARTS HERE

library SafeMath {
  function mul(uint256 a, uint256 b) constant public returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) constant public returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) constant public returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) constant public returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
