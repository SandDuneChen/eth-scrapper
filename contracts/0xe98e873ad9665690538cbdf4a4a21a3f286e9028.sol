
//Address: 0xe98e873ad9665690538cbdf4a4a21a3f286e9028
//Contract name: WithdrawDAO
//Balance: 0.01 Ether
//Verification Date: 8/6/2016
//Transacion Count: 4

// CODE STARTS HERE

// Refund contract for trust DAO #65

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0xa2f1ccba9395d7fcb155bba8bc92db9bafaeade7);
    address constant public trustee = 0xda4a4626d3e16e094de3225a751aab7128e96526;

    function withdraw(){
        uint balance = mainDAO.balanceOf(msg.sender);

        if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
            throw;
    }

    function trusteeWithdraw() {
        trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());
    }
}
