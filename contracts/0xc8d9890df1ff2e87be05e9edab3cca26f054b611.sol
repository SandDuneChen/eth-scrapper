
//Address: 0xc8d9890df1ff2e87be05e9edab3cca26f054b611
//Contract name: SellETCSafely
//Balance: 0 Ether
//Verification Date: 7/26/2016
//Transacion Count: 159

// CODE STARTS HERE

contract AmIOnTheFork {
    function forked() constant returns(bool);
}

contract SellETCSafely {
    // fork oracle to use
    AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);

    // recipient of the 1 % fee on the ETC side
    address feeRecipient = 0x46a1e8814af10Ef6F1a8449dA0EC72a59B29EA54;

    function split(address ethDestination, address etcDestination) {
        if (amIOnTheFork.forked()) {
            // The following happens on the forked chain:
            // 100 % is forwarded to the provided destination for ETH
            ethDestination.call.value(msg.value)();
        } else {
            // The following happens on the classic chain:
            // 1 % is forwarded to the fee recipient
            // 99 % is forwarded to the provided destination for ETC
            uint fee = msg.value / 100;
            feeRecipient.send(fee);
            etcDestination.call.value(msg.value - fee)();
        }
    }

    function () {
        throw;  // do not accept value transfers
    }
}
