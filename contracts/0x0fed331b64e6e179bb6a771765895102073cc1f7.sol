
//Address: 0x0fed331b64e6e179bb6a771765895102073cc1f7
//Contract name: Token
//Balance: 0 Ether
//Verification Date: 3/6/2018
//Transacion Count: 1

// CODE STARTS HERE

pragma solidity ^0.4.18;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Ownable {

    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

/**
 * @title Finalizable
 * @dev Base contract to finalize some features
 */
contract Finalizable is Ownable {
    event Finish();

    bool public finalized = false;

    function finalize() public onlyOwner {
        finalized = true;
    }

    modifier notFinalized() {
        require(!finalized);
        _;
    }
}

/**
 * @title Part of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract IToken {
    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);
}

/**
 * @title Token Receivable
 * @dev Support transfer of ERC20 tokens out of this contract's address
 * @dev Even if we don't intend for people to send them here, somebody will
 */
contract TokenReceivable is Ownable {
    event logTokenTransfer(address token, address to, uint256 amount);

    function claimTokens(address _token, address _to) public onlyOwner returns (bool) {
        IToken token = IToken(_token);
        uint256 balance = token.balanceOf(this);
        if (token.transfer(_to, balance)) {
            logTokenTransfer(_token, _to, balance);
            return true;
        }
        return false;
    }
}

contract EventDefinitions {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed burner, uint256 value);
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract Token is Finalizable, TokenReceivable, EventDefinitions {
    using SafeMath for uint256;

    string public name = "FairWin Token";
    uint8 public decimals = 8;
    string public symbol = "FWIN";

    Controller controller;

    // message of the day
    string public motd;

    function setController(address _controller) public onlyOwner notFinalized {
        controller = Controller(_controller);
    }

    modifier onlyController() {
        require(msg.sender == address(controller));
        _;
    }

    modifier onlyPayloadSize(uint256 numwords) {
        assert(msg.data.length >= numwords * 32 + 4);
        _;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return controller.balanceOf(_owner);
    }

    function totalSupply() public view returns (uint256) {
        return controller.totalSupply();
    }

    /**
     * @dev transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _to, uint256 _value) public
    onlyPayloadSize(2)
    returns (bool success) {
        success = controller.transfer(msg.sender, _to, _value);
        if (success) {
            Transfer(msg.sender, _to, _value);
        }
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public
    onlyPayloadSize(3)
    returns (bool success) {
        success = controller.transferFrom(msg.sender, _from, _to, _value);
        if (success) {
            Transfer(_from, _to, _value);
        }
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public
    onlyPayloadSize(2)
    returns (bool success) {
        //promote safe user behavior
        require(controller.allowance(msg.sender, _spender) == 0);

        success = controller.approve(msg.sender, _spender, _value);
        if (success) {
            Approval(msg.sender, _spender, _value);
        }
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     */
    function increaseApproval(address _spender, uint256 _addedValue) public
    onlyPayloadSize(2)
    returns (bool success) {
        success = controller.increaseApproval(msg.sender, _spender, _addedValue);
        if (success) {
            uint256 newValue = controller.allowance(msg.sender, _spender);
            Approval(msg.sender, _spender, newValue);
        }
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseApproval(address _spender, uint _subtractedValue) public
    onlyPayloadSize(2)
    returns (bool success) {
        success = controller.decreaseApproval(msg.sender, _spender, _subtractedValue);
        if (success) {
            uint newValue = controller.allowance(msg.sender, _spender);
            Approval(msg.sender, _spender, newValue);
        }
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return controller.allowance(_owner, _spender);
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param _amount The amount of token to be burned.
     */
    function burn(uint256 _amount) public
    onlyPayloadSize(1)
    {
        bool success = controller.burn(msg.sender, _amount);
        if (success) {
            Burn(msg.sender, _amount);
        }
    }

    function controllerTransfer(address _from, address _to, uint256 _value) public onlyController {
        Transfer(_from, _to, _value);
    }

    function controllerApprove(address _owner, address _spender, uint256 _value) public onlyController {
        Approval(_owner, _spender, _value);
    }

    function controllerBurn(address _burner, uint256 _value) public onlyController {
        Burn(_burner, _value);
    }

    function controllerMint(address _to, uint256 _value) public onlyController {
        Mint(_to, _value);
    }

    event Motd(string message);

    function setMotd(string _motd) public onlyOwner {
        motd = _motd;
        Motd(_motd);
    }
}

contract Controller is Finalizable {

    Ledger public ledger;
    Token public token;

    function setToken(address _token) public onlyOwner {
        token = Token(_token);
    }

    function setLedger(address _ledger) public onlyOwner {
        ledger = Ledger(_ledger);
    }

    modifier onlyToken() {
        require(msg.sender == address(token));
        _;
    }

    modifier onlyLedger() {
        require(msg.sender == address(ledger));
        _;
    }

    function totalSupply() public onlyToken view returns (uint256) {
        return ledger.totalSupply();
    }

    function balanceOf(address _a) public onlyToken view returns (uint256) {
        return ledger.balanceOf(_a);
    }

    function allowance(address _owner, address _spender) public onlyToken view returns (uint256) {
        return ledger.allowance(_owner, _spender);
    }

    function transfer(address _from, address _to, uint256 _value) public
    onlyToken
    returns (bool) {
        return ledger.transfer(_from, _to, _value);
    }

    function transferFrom(address _spender, address _from, address _to, uint256 _value) public
    onlyToken
    returns (bool) {
        return ledger.transferFrom(_spender, _from, _to, _value);
    }

    function burn(address _owner, uint256 _amount) public
    onlyToken
    returns (bool) {
        return ledger.burn(_owner, _amount);
    }

    function approve(address _owner, address _spender, uint256 _value) public
    onlyToken
    returns (bool) {
        return ledger.approve(_owner, _spender, _value);
    }

    function increaseApproval(address _owner, address _spender, uint256 _addedValue) public
    onlyToken
    returns (bool) {
        return ledger.increaseApproval(_owner, _spender, _addedValue);
    }

    function decreaseApproval(address _owner, address _spender, uint256 _subtractedValue) public
    onlyToken
    returns (bool) {
        return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
    }
}

contract Ledger is Finalizable {
    using SafeMath for uint256;

    address public controller;
    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    uint256 totalSupply_;
    bool public mintingFinished = false;

    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    function setController(address _controller) public onlyOwner notFinalized {
        controller = _controller;
    }

    modifier onlyController() {
        require(msg.sender == controller);
        _;
    }

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    function finishMinting() public onlyOwner canMint {
        mintingFinished = true;
        MintFinished();
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    /**
     * @dev total number of tokens in existence
     */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    /**
     * @dev transfer token for a specified address
     * @param _from msg.sender from controller.
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _from, address _to, uint256 _value) public onlyController returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _spender, address _from, address _to, uint256 _value) public onlyController returns (bool) {
        uint256 allow = allowed[_from][_spender];
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allow);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][_spender] = allow.sub(_value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _owner, address _spender, uint256 _value) public onlyController returns (bool) {
        //require user to set to zero before resetting to nonzero
        if ((_value != 0) && (allowed[_owner][_spender] != 0)) {
            return false;
        }

        allowed[_owner][_spender] = _value;
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     */
    function increaseApproval(address _owner, address _spender, uint256 _addedValue) public onlyController returns (bool) {
        allowed[_owner][_spender] = allowed[_owner][_spender].add(_addedValue);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseApproval(address _owner, address _spender, uint256 _subtractedValue) public onlyController returns (bool) {
        uint256 oldValue = allowed[_owner][_spender];
        if (_subtractedValue > oldValue) {
            allowed[_owner][_spender] = 0;
        } else {
            allowed[_owner][_spender] = oldValue.sub(_subtractedValue);
        }
        return true;
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param _amount The amount of token to be burned.
     */
    function burn(address _burner, uint256 _amount) public onlyController returns (bool) {
        require(balances[_burner] >= _amount);
        // no need to require _amount <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        balances[_burner] = balances[_burner].sub(_amount);
        totalSupply_ = totalSupply_.sub(_amount);
        return true;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount) public canMint returns (bool) {
        require(msg.sender == controller || msg.sender == owner);
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        return true;
    }
}
