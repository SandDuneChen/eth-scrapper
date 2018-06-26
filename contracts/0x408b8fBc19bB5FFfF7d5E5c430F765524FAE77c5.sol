
//Address: 0x408b8fBc19bB5FFfF7d5E5c430F765524FAE77c5
//Contract name: WithdrawDAO
//Balance: 0.05 Ether
//Verification Date: 7/14/2016
//Transacion Count: 4

// CODE STARTS HERE

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0xbb9bc244d798123fde783fcc1c72d3bb8c189413);
    address public trustee = 0xcdf7D2D0BdF3511FFf511C62f3C218CF98A136eB; // to be replaced by a multisig

    function withdraw(){
        uint balance = mainDAO.balanceOf(msg.sender);

        if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
            throw;
    }

    function trusteeWithdraw() {
        trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());
    }
}
