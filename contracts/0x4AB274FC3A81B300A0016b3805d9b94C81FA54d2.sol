
//Address: 0x4AB274FC3A81B300A0016b3805d9b94C81FA54d2
//Contract name: MeatConversionCalculator
//Balance: 0 Ether
//Verification Date: 10/2/2016
//Transacion Count: 2

// CODE STARTS HERE

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}



contract MeatConversionCalculator is owned {
    uint public amountOfMeatInUnicorn;
    uint public reliabilityPercentage;

    /* generates a number from 0 to 2^n based on the last n blocks */
    function multiBlockRandomGen(uint seed, uint size) constant returns (uint randomNumber) {
        uint n = 0;
        for (uint i = 0; i < size; i++){
            if (uint(sha3(block.blockhash(block.number-i-1), seed ))%2==0)
                n += 2**i;
        }
        return n;
    }
    
    function MeatConversionCalculator(
        uint averageAmountOfMeatInAUnicorn, 
        uint percentOfThatMeatThatAlwaysDeliver
    ) {
        changeMeatParameters(averageAmountOfMeatInAUnicorn, percentOfThatMeatThatAlwaysDeliver);
    }
    function changeMeatParameters(
        uint averageAmountOfMeatInAUnicorn, 
        uint percentOfThatMeatThatAlwaysDeliver
    ) onlyOwner {
        amountOfMeatInUnicorn = averageAmountOfMeatInAUnicorn * 1000;
        reliabilityPercentage = percentOfThatMeatThatAlwaysDeliver;
    }
    
    function calculateMeat(uint amountOfUnicorns) constant returns (uint amountOfMeat) {
        uint rnd = multiBlockRandomGen(uint(sha3(block.number, now, amountOfUnicorns)), 10);

       amountOfMeat = (reliabilityPercentage*amountOfUnicorns*amountOfMeatInUnicorn)/100;
       amountOfMeat += (1024*(100-reliabilityPercentage)*amountOfUnicorns*amountOfMeatInUnicorn)/(rnd*100);

    }
}
