
//Address: 0x30b82a61e9c7ecca057f8dd42e67c628d7e1b823
//Contract name: WithdrawDAO
//Balance: 0 Ether
//Verification Date: 8/6/2016
//Transacion Count: 6

// CODE STARTS HERE

// Refund contract for trust DAO #10

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0x5c8536898fbb74fc7445814902fd08422eac56d0);
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
