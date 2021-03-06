
//Address: 0xba95b83766d60170e78398745f5c3df78b886c65
//Contract name: WithdrawDAO
//Balance: 0.01 Ether
//Verification Date: 8/6/2016
//Transacion Count: 4

// CODE STARTS HERE

// Refund contract for trust DAO #23

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0x9f27daea7aca0aa0446220b98d028715e3bc803d);
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
