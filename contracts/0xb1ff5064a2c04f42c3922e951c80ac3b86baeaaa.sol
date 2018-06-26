
//Address: 0xb1ff5064a2c04f42c3922e951c80ac3b86baeaaa
//Contract name: CreditBOND
//Balance: 0 Ether
//Verification Date: 4/18/2017
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.8;

contract CreditBOND {
    
    uint public yearlyBlockCount = 2102400;
    
    function getBondMultiplier(uint _creditAmount, uint _locktime) constant returns (uint bondMultiplier){

        if (_locktime >= block.number + yearlyBlockCount * 2) { return 0; }
        
        uint answer = 0;
        if (_locktime > block.number){
            if (_locktime < 175200 + block.number){ // 1 month
                answer = 1;
            }else if(_locktime < 525600 + block.number){ // 3 months
                answer = 3;
            }else if(_locktime < 1051200 + block.number){ // 6 months
                answer = 6;
            }else if (_locktime < 2102400 + block.number){ // 12 months
                answer = 8;
            }else{
                answer = 12;
            }
        }
        return answer;
    }
    
    function getNewCoinsIssued(uint _lockedBalance, uint _blockDifference, uint _percentReward) constant returns(uint newCoinsIssued){
        return (_percentReward*_lockedBalance*_blockDifference)/(100*yearlyBlockCount);
    }
}
