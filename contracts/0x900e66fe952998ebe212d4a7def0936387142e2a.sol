
//Address: 0x900e66fe952998ebe212d4a7def0936387142e2a
//Contract name: WithdrawDAO
//Balance: 0 Ether
//Verification Date: 8/4/2016
//Transacion Count: 1

// CODE STARTS HERE

// Refund contract for trust DAO #28

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0x492ea3bb0f3315521c31f273e565b868fc090f17);
    address public trustee = 0xb18e6467db64686dfed14c7368ca59e5019c95c8;

    function withdraw(){
        uint balance = mainDAO.balanceOf(msg.sender);

        if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
            throw;
    }

    function trusteeWithdraw() {
        trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());
    }
}
