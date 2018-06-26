
//Address: 0xa333604269d38faec526d90db381017009fe4c18
//Contract name: WithdrawDAO
//Balance: 0 Ether
//Verification Date: 8/4/2016
//Transacion Count: 1

// CODE STARTS HERE

// Refund contract for trust DAO #60

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0x4deb0033bb26bc534b197e61d19e0733e5679784);
    address public trustee = 0x65c407ffea9fcff194fe9d3335d2b78416226056;

    function withdraw(){
        uint balance = mainDAO.balanceOf(msg.sender);

        if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
            throw;
    }

    function trusteeWithdraw() {
        trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());
    }
}
