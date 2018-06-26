
//Address: 0xFAe8c1c08360a9B4465eC3244C6a04881b422Ed5
//Contract name: Crowdsale
//Balance: 0 Ether
//Verification Date: 4/19/2018
//Transacion Count: 75

// CODE STARTS HERE

pragma solidity ^0.4.21;
interface SisterToken {function _buy(address _for)external payable;function testConnection() external;}
contract owned {
    address public owner;
    event Log(string s);

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
    function isOwner()public{
        if(msg.sender==owner)emit Log("Owner");
        else{
            emit Log("Not Owner");
        }
    }
}
contract Crowdsale is owned {
    address public Nplay;
    address public Eplay;
    function Crowdsale() public payable{
    }
    function () public payable{
        buy();
    }
    function setEplay(address newSS)public onlyOwner{
        Eplay= newSS;
    }
    function setNplay(address newSS)public onlyOwner {
        Nplay= newSS;
    }
    function buy()public payable{
        SisterToken E = SisterToken(Eplay);
        SisterToken N = SisterToken(Nplay);
        E._buy.value(msg.value/2)(msg.sender);
        N._buy.value(msg.value/2)(msg.sender);
    }
    function connectTest() public payable{
        SisterToken S = SisterToken(Eplay);
        SisterToken N = SisterToken(Nplay);
        S.testConnection();
        N.testConnection();
    }
}
