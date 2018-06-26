
//Address: 0x4ae979ec00e08ba7350d9f12777528cf4f84109c
//Contract name: Cornholio
//Balance: 0 Ether
//Verification Date: 2/12/2018
//Transacion Count: 406

// CODE STARTS HERE

pragma solidity ^0.4.19;

interface CornFarm
{
    function buyObject(address _beneficiary) public payable;
}

interface Corn
{
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
}

contract Cornholio
{
    address public farmer = 0x231F702070aACdbde867B323996A96Fed8aDCA10;
    
    function sowCorn(address soil, uint8 seeds) external
    {
        for(uint8 i = 0; i < seeds; ++i)
        {
            CornFarm(soil).buyObject(this);
        }
    }
    
    function reap(address corn) external
    {
        Corn(corn).transfer(farmer, Corn(corn).balanceOf(this));
    }
}
