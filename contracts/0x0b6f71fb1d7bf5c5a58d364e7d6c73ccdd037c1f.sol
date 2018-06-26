
//Address: 0x0b6f71fb1d7bf5c5a58d364e7d6c73ccdd037c1f
//Contract name: TokenCrowdsale
//Balance: 0.003212182176183546 Ether
//Verification Date: 6/4/2018
//Transacion Count: 7

// CODE STARTS HERE

pragma solidity ^0.4.0;

contract owned {

    address public owner;

    function owned() payable {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function changeOwner(address _owner) onlyOwner public {
        owner = _owner;
    }
}

contract TraceCrowdsale is owned {
    
    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function TraceCrowdsale() payable owned() {
        totalSupply = 5000000;
        balanceOf[this] = 2500000;
        balanceOf[owner] = totalSupply - balanceOf[this];
        Transfer(this, owner, balanceOf[owner]);
    }

    function () payable {
        require(balanceOf[this] > 0);
        uint256 tokensPerOneEther = 5000;
        uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
        if (tokens > balanceOf[this]) {
            tokens = balanceOf[this];
            uint valueWei = tokens * 1000000000000000000 / 5000;
            msg.sender.transfer(msg.value - valueWei);
        }
        require(tokens > 0);
        balanceOf[msg.sender] += tokens;
        balanceOf[this] -= tokens;
        Transfer(this, msg.sender, tokens);
    }
}

contract TraceToken is TraceCrowdsale {
    
    string  public standard    = 'Token 0.1';
    string  public name        = 'TraceToken';
    string  public symbol      = "TACE";
    uint8   public decimals    = 0;

    function TraceToken() payable TraceCrowdsale() {}

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }
}

contract TokenCrowdsale is TraceToken {

    function TokenCrowdsale() payable TraceToken() {}
    
    function withdraw() public onlyOwner {
        owner.transfer(this.balance);
    }
    
    function killMe() public onlyOwner {
        selfdestruct(owner);
    }
}
