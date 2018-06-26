
//Address: 0xe0973da8c1d31fc4019628ea72a56c4f041aaa4a
//Contract name: calculator
//Balance: 0 Ether
//Verification Date: 11/21/2017
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.18;

contract calculator{
    
    uint number;
    uint multiply;
    uint divide;
    uint plus;
    uint subtract;
    
    function Integer(uint theNumber){
        number = theNumber;
    }
    
    function Multiplier(uint multiplyAmount){
        multiply = multiplyAmount;
        number = number * multiplyAmount;
    }
    
    function Divider(uint divideAmount){
        divide = divideAmount;
        number = number / divideAmount;
    }
    
    function AddAmount(uint addAmount){
        plus = addAmount;
        number = number + addAmount;
    }
    
    function SubtractAmount(uint subtractAmount){
        subtract = subtractAmount;
        number = number - subtractAmount;
    }
    
    function getAnswer() constant returns (uint){
        return number; 
    }
}
