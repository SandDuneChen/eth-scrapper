
//Address: 0x0dc11b7ed751594906bce3a7091952b30528ee7e
//Contract name: DickMeasurementContest
//Balance: 0.01 Ether
//Verification Date: 2/27/2018
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.17;

contract DickMeasurementContest {

    uint lastBlock;
    address owner;

    modifier onlyowner {
        require (msg.sender == owner);
        _;
    }

    function DickMeasurementContest() public {
        owner = msg.sender;
    }

    function () public payable {}

    function mineIsBigger() public payable {
        if (msg.value > this.balance) {
            owner = msg.sender;
            lastBlock = now;
        }
    }

    function withdraw() public onlyowner {
        // if there are no contestants within 3 days
        // the winner is allowed to take the money
        require(now > lastBlock + 3 days);
        msg.sender.transfer(this.balance);
    }

    function kill() public onlyowner {
        if(this.balance == 0) {  
            selfdestruct(msg.sender);
        }
    }
}
