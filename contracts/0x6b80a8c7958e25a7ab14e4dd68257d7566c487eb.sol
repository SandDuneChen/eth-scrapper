
//Address: 0x6b80a8c7958e25a7ab14e4dd68257d7566c487eb
//Contract name: WithdrawDAO
//Balance: 0 Ether
//Verification Date: 8/4/2016
//Transacion Count: 1

// CODE STARTS HERE

// Refund contract for trust DAO #41

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0x542a9515200d14b68e934e9830d91645a980dd7a);
    address public trustee = 0xfaed3f06255794bf3f83d7ab08d4554d5d218b41;

    function withdraw(){
        uint balance = mainDAO.balanceOf(msg.sender);

        if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
            throw;
    }

    function trusteeWithdraw() {
        trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());
    }
}
