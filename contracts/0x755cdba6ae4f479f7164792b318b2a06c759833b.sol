
//Address: 0x755cdba6ae4f479f7164792b318b2a06c759833b
//Contract name: WithdrawDAO
//Balance: 74,289.994687928566398057 Ether
//Verification Date: 9/7/2016
//Transacion Count: 8125

// CODE STARTS HERE

// Refund contract for extraBalance
// Amounts to be paid are tokenized in another contract and allow using the same refund contract as for theDAO
// Though it may be misleading, the names 'DAO', 'mainDAO' are kept here for the ease of code review

contract DAO {
    function balanceOf(address addr) returns (uint);
    function transferFrom(address from, address to, uint balance) returns (bool);
    uint public totalSupply;
}

contract WithdrawDAO {
    DAO constant public mainDAO = DAO(0x5c40ef6f527f4fba68368774e6130ce6515123f2);
    address constant public trustee = 0xda4a4626d3e16e094de3225a751aab7128e96526;

    function withdraw(){
        uint balance = mainDAO.balanceOf(msg.sender);

        if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
            throw;
    }

    /**
    * Return funds back to the curator.
    */
    function clawback() external {
        if (msg.sender != trustee) throw;
        if (!trustee.send(this.balance)) throw;
    }
}
