
//Address: 0x1cA5de96F331E99A5FB87b739C8A0228B6416675
//Contract name: SafeMathLibExt
//Balance: 0 Ether
//Verification Date: 2/3/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.6; /** * Safe unsigned safe math. * * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli * * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol * * Maintained here until merged to mainline zeppelin-solidity. * */ library SafeMathLibExt { function times(uint a, uint b) returns (uint) { uint c = a * b; assert(a == 0 || c / a == b); return c; } function divides(uint a, uint b) returns (uint) { assert(b > 0); uint c = a / b; assert(a == b * c + a % b); return c; } function minus(uint a, uint b) returns (uint) { assert(b <= a); return a - b; } function plus(uint a, uint b) returns (uint) { uint c = a + b; assert(c>=a); return c; } }
