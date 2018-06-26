
//Address: 0x8cd68336ad5092110e79aae318731e1d60a331ae
//Contract name: WithdrawDAO
//Balance: 0 Ether
//Verification Date: 8/6/2016
//Transacion Count: 1

// CODE STARTS HERE

// Refund contract for trust DAO #31

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0xcc34673c6c40e791051898567a1222daf90be287);
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
