
//Address: 0x06d769892ef99d18a344cd95909d394a5ddb2efb
//Contract name: MGCGameToken
//Balance: 0 Ether
//Verification Date: 4/16/2018
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity ^0.4.21;

contract MGCGameToken {
    // Track how many tokens are owned by each address.
    mapping (address => uint256) public balanceOf;

    string public name = "MGC Game Coin";
    string public symbol = "MGC";
    uint8 public decimals = 8;

    uint256 public totalSupply = 1000000000 * (uint256(10) ** decimals);

    event Transfer(address indexed from, address indexed to, uint256 value);

    function MGCGameToken() public {
        // Initially assign all tokens to the contract's creator.
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;  // deduct from sender's balance
        balanceOf[to] += value;          // add to recipient's balance
        emit Transfer(msg.sender, to, value);
        return true;
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;

    function approve(address spender, uint256 value)
        public
        returns (bool success)
    {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value)
        public
        returns (bool success)
    {
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
}