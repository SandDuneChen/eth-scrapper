
//Address: 0xed18ea2286368906d1c04bf020b3076962f263e7
//Contract name: Indorser
//Balance: 0 Ether
//Verification Date: 5/31/2018
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.23;

contract Token{
  function transfer(address to, uint value) returns (bool);
}

contract Indorser {
    function multisend(address _tokenAddr, address[] _to, uint256[] _value)
    returns (bool _success) {
        assert(_to.length == _value.length);
        assert(_to.length <= 150);
        // loop through to addresses and send value
        for (uint8 i = 0; i < _to.length; i++) {
                assert((Token(_tokenAddr).transfer(_to[i], _value[i])) == true);
            }
            return true;
        }
}
