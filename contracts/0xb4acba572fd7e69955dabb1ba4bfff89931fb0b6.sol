
//Address: 0xb4acba572fd7e69955dabb1ba4bfff89931fb0b6
//Contract name: GetDecimals
//Balance: 0 Ether
//Verification Date: 5/7/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.23;

interface ERC20 {
    function decimals() external view returns(uint);
}

contract GetDecimals {
    function getDecimals(ERC20 token) external view returns (uint){
        bytes memory data = abi.encodeWithSignature("decimals()");
        if(!address(token).call(data)) {
            // call failed
            return 18;
        }
        else {
            return token.decimals();
        }
    }
    
    function getDecimalsBetter(ERC20 token) external view returns(uint) {
        bytes memory data = abi.encodeWithSignature("decimals()");
        uint[1] memory value;
        if(!address(token).call(data)) {
            // call failed
            return 18;
        }
        else {
            assembly {
                returndatacopy(value,0,returndatasize)
                
            }
            
            return value[0];
        }
    }
    
    function testRevert() public pure returns(string) {
        revert("ilan is the king");
        return "hello world";
    }
    
    function testRevertTx() public returns(string) {
        return testRevert();
    }    
}
