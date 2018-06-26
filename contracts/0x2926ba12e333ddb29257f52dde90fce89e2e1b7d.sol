
//Address: 0x2926ba12e333ddb29257f52dde90fce89e2e1b7d
//Contract name: HodlDAO
//Balance: 0 Ether
//Verification Date: 4/29/2017
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.10;
/**
* Hodld DAO and ERC20 token
* Author: CurrencyTycoon on GitHub
* License: MIT
* Date: 2017
*
* Deploy with the following args:
* 0, "Hodl DAO", 18, "HODL"
*
*/
contract HodlDAO {
    /* ERC20 Public variables of the token */
    string public version = 'HDAO 0.3';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    /* ERC20 This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;


    /* store the block number when a withdrawal has been requested*/
    mapping (address => withdrawalRequest) public withdrawalRequests;
    struct withdrawalRequest {
        uint sinceBlock;
        uint256 amount;
    }

    /**
     * feePot collects fees from quick withdrawals. This gets re-distributed to slow-withdrawals
    */
    uint256 public feePot;

    uint32 public constant blockWait = 172800; // roughly 30 days,  (2592000 / 15) - assuming block time is ~15 sec.
    //uint public constant blockWait = 8; // roughly assuming block time is ~15 sec. (uncomment when testing on testnet)


    /**
     * ERC20 events these generate a public event on the blockchain that will notify clients
    */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event WithdrawalQuick(address indexed by, uint256 amount, uint256 fee); // quick withdrawal done
    event InsufficientFee(address indexed by, uint256 feeRequired);  // not enough fee paid for quick withdrawal
    event WithdrawalStarted(address indexed by, uint256 amount);
    event WithdrawalDone(address indexed by, uint256 amount, uint256 reward); // amount is the amount that was used to calculate reward
    event WithdrawalPremature(address indexed by, uint blocksToWait); // Needs to wait blocksToWait before withdrawal unlocked
    event Deposited(address indexed by, uint256 amount);

    /**
     * Initializes contract with initial supply tokens to the creator of the contract
     * In our case, there's no initial supply. Tokens will be created as ether is sent
     * to the fall-back function. Then tokens are burned when ether is withdrawn.
     */
    function HodlDAO(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol
    ) {

        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        totalSupply = initialSupply;                        // Update total supply
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }

    /**
     * notPendingWithdrawal modifier guards the function from executing when a
     * withdrawal has been requested and is currently pending
     */
    modifier notPendingWithdrawal {
        if (withdrawalRequests[msg.sender].sinceBlock > 0) throw;
        _;
    }

    /** ERC20 - transfer sends tokens
     * @notice send `_value` token to `_to` from `msg.sender`
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return Whether the transfer was successful or not
     */
    function transfer(address _to, uint256 _value) notPendingWithdrawal {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }

    /** ERC20 approve allows another contract to spend some tokens in your behalf
     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
     * @param _spender The address of the account able to transfer the tokens
     * @param _value The amount of tokens to be approved for transfer
     * @return Whether the approval was successful or not
     *
     *
     * Note, there are some edge-cases with the ERC-20 approve mechanism. In this case a 'bounds check'
     * was added to make sure Alice cant' approve Bob for more tokens than she has.
     * The assumptions are that these scenarios could still happen if not mitigated by Alice:
     *
     * Scenario 1:
     *
     * The following scenario could be the expected outcome by Alice, but if not, Alice would need to set
     * her approval to Bob to 0 before Alice purchases more tokens.
     *
     *  1. Alice has 100 tokens.
     *  2. Alice approves 50 tokens for Bob.
     *  3. Alice approves 100 tokens for Charles
     *  4. Bob calls transferFrom and receives his 50 tokens.
     *  5. Charles calls transferFrom and receives the remaining 50 tokens
     *  6. Charles still has an approval for 50 more tokens from Alice, even though she now owns 0 tokens.
     *  7. Alice purchases 50 more tokens
     *  8. Charles sees this, and immediately calls transferFrom and receives those 50 tokens.
     *
     * Scenario 2:
     *
     * This is a race condition. To mitigate this problem, Alice should set the allowance to 0 in step 2,
     * then wait until it's mined, then if Bob didn't take the 100 she can set to 50. (Otherwise Bob may
     * potentially get 150 tokens)
     *
     *
     *  1. Alice approves Bob for 100,
     *  2. Alice changes it to 50
     *  3. Bob sees the change in the mempool before it's mined, and sends a new transaction
     *     that will hopefully win the race and withdraw the 100 first, meanwhile the 50 will
     *     be mined after and allow Bob to withdraw another 50.
     *
     *
     */
    function approve(address _spender, uint256 _value) notPendingWithdrawal
    returns (bool success) {
        if (balanceOf[msg.sender] < _value) return false; // Don't allow more than they currently have (bounds check)
        // To change the approve amount you first have to reduce the addresses´
        //  allowance to zero by calling `approve(_spender,0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) throw;
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;                                      // we must return a bool as part of the ERC20
    }


    /**
     * ERC-20 Approves and then calls the receiving contract
    */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) notPendingWithdrawal
    returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
            throw;
        }
        return true;
    }

    /**
     * ERC20 A contract attempts to get the coins
     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return Whether the transfer was successful or not
     */
    function transferFrom(address _from, address _to, uint256 _value)
    returns (bool success) {
        // note that we can't use notPendingWithdrawal modifier here since this function does a transfer
        // on the behalf of _from
        if (withdrawalRequests[_from].sinceBlock > 0) throw;  // can't move tokens when _from is pending withdrawal
        if (withdrawalRequests[_to].sinceBlock > 0) throw;    // can't move tokens when _to is pending withdrawal
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
        balanceOf[_from] -= _value;                           // Subtract from the sender
        balanceOf[_to] += _value;                             // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    /**
     * withdrawalInitiate initiates the withdrawal by going into a waiting period
     * It remembers the block number & amount held at the time of request.
     * Tokens cannot be moved out during the waiting period, locking the tokens until then.
     * After the waiting period finishes, the call withdrawalComplete
     *
     * Gas: 64490
     *
     */
    function withdrawalInitiate() notPendingWithdrawal {
        WithdrawalStarted(msg.sender, balanceOf[msg.sender]);
        withdrawalRequests[msg.sender] = withdrawalRequest(block.number, balanceOf[msg.sender]);
    }

    /**
     * withdrawalComplete is called after the waiting period. The ether will be
     * returned to the caller and the tokens will be burned.
     * A reward will be issued based on the current amount in the feePot, relative to the
     * amount that was requested for withdrawal when withdrawalInitiate() was called.
     *
     * Gas: 30946
     */
    function withdrawalComplete() returns (bool) {
        withdrawalRequest r = withdrawalRequests[msg.sender];
        if (r.sinceBlock == 0) throw;
        if ((r.sinceBlock + blockWait) > block.number) {
            // holder needs to wait some more blocks
            WithdrawalPremature(msg.sender, r.sinceBlock + blockWait - block.number);
            return false;
        }
        uint256 amount = withdrawalRequests[msg.sender].amount;
        uint256 reward = calculateReward(r.amount);
        withdrawalRequests[msg.sender].sinceBlock = 0;  // This will unlock the holders tokens
        withdrawalRequests[msg.sender].amount = 0;      // clear the amount that was requested

        if (reward > 0) {
            if (feePot - reward > feePot) {
                feePot = 0; // overflow
            } else {
                feePot -= reward;
            }
        }
        doWithdrawal(reward);                           // burn the tokens and send back the ether
        WithdrawalDone(msg.sender, amount, reward);
        return true;

    }

    /**
     * Reward is based on the amount held, relative to total supply of tokens.
     */
    function calculateReward(uint256 v) constant returns (uint256) {
        uint256 reward = 0;
        if (feePot > 0) {
            reward = feePot * v / totalSupply;
        }
        return reward;
    }

    /** calculate the fee for quick withdrawal
     */
    function calculateFee(uint256 v) constant returns  (uint256) {
        uint256 feeRequired = v / 100; // 1%
        return feeRequired;
    }

    /**
     * Quick withdrawal, needs to send ether to this function for the fee.
     *
     * Gas use: 35384 (including call to processWithdrawal)
    */
    function quickWithdraw() payable notPendingWithdrawal returns (bool) {
        // calculate required fee
        uint256 amount = balanceOf[msg.sender];
        if (amount <= 0) throw;
        uint256 feeRequired = calculateFee(amount);
        if (msg.value < feeRequired) {
            InsufficientFee(msg.sender, feeRequired); // not enough fees sent
            return false;
        }
        uint256 overAmount = msg.value - feeRequired; // calculate any over-payment

        feePot += msg.value - overAmount;             // add fee to the feePot, excluding any over-payment

        doWithdrawal(overAmount);                     // withdraw + return any over payment
        WithdrawalDone(msg.sender, amount, 0);
        return true;
    }

    /**
     * do withdrawal
     */
    function doWithdrawal(uint256 extra) internal {
        uint256 amount = balanceOf[msg.sender];
        if (amount <= 0) throw;                      // cannot withdraw
        if (amount + extra > this.balance) {
            throw;                                   // contract doesn't have enough balance
        }
        balanceOf[msg.sender] = 0;
        if (totalSupply > totalSupply - amount) {
            totalSupply = 0;                         // don't let it overflow
        } else {
            totalSupply -= amount;                   // deflate the supply!
        }
        Transfer(msg.sender, 0, amount);             // burn baby burn
        if (!msg.sender.send(amount + extra)) throw; // return back the ether or rollback if failed
    }


    /**
     * Fallback function when sending ether to the contract
     * Gas use: 65051
    */
    function () payable notPendingWithdrawal {
        uint256 amount = msg.value;         // amount that was sent
        if (amount <= 0) throw;             // need to send some ETH
        balanceOf[msg.sender] += amount;    // mint new tokens
        totalSupply += amount;              // track the supply
        Transfer(0, msg.sender, amount);    // notify of the event
        Deposited(msg.sender, amount);
    }
}