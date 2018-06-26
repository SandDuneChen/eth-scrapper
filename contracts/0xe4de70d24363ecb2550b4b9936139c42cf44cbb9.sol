
//Address: 0xe4de70d24363ecb2550b4b9936139c42cf44cbb9
//Contract name: Owned
//Balance: 0 Ether
//Verification Date: 8/1/2017
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ~0.4.13;
contract Owned  {

    address public owner;
    address public newOwner;

    function Owned() {
        owner = msg.sender;
        newOwner = 0xe18Af0dDA74fC4Ee90bCB37E45b4BD623dC6e099;
    }

    function transferOwnership(address _newOwner) only(owner) {
        newOwner = _newOwner;
    }

    function acceptOwnership() only(newOwner) {
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
    
    function sayHello(string hello) {
        LogStr(hello);
    }

    event OwnershipTransferred(address indexed _from, address indexed _to);
    
    event LogStr(string hello);
    
    modifier only(address allowed) {
        if (msg.sender != allowed) revert();
        _;
    }
    
    function finalize()only(owner){
        selfdestruct(owner);
    } 


}
