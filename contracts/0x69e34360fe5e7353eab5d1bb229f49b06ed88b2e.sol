
//Address: 0x69e34360fe5e7353eab5d1bb229f49b06ed88b2e
//Contract name: ExchangeRate
//Balance: 0 Ether
//Verification Date: 1/22/2018
//Transacion Count: 2

// CODE STARTS HERE

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control 
 * functions, this simplifies the implementation of "user permissions". 
 */
contract Ownable {
  address public owner;

  /** 
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
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
  function transferOwnership(address newOwner) onlyOwner public {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}


/**
 * @title ExchangeRate
 * @dev Allows updating and retrieveing of Conversion Rates for ABLE tokens
 *
 * ABI
 * [{"constant": false,"inputs": [{"name": "_symbol","type": "string"},{"name": "_rate","type": "uint256"}],"name": "updateRate","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "data","type": "uint256[]"}],"name": "updateRates","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "_symbol","type": "string"}],"name": "getRate","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [{"name": "","type": "bytes32"}],"name": "rates","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"anonymous": false,"inputs": [{"indexed": false,"name": "timestamp","type": "uint256"},{"indexed": false,"name": "symbol","type": "bytes32"},{"indexed": false,"name": "rate","type": "uint256"}],"name": "RateUpdated","type": "event"}]
 */
contract ExchangeRate is Ownable {

  event RateUpdated(uint timestamp, bytes32 symbol, uint rate);

  mapping(bytes32 => uint) public rates;

  /**
   * @dev Allows the current owner to update a single rate.
   * @param _symbol The symbol to be updated. 
   * @param _rate the rate for the symbol. 
   */
  function updateRate(string _symbol, uint _rate) public onlyOwner {
    rates[sha3(_symbol)] = _rate;
    RateUpdated(now, sha3(_symbol), _rate);
  }

  /**
   * @dev Allows the current owner to update multiple rates.
   * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
   */
  function updateRates(uint[] data) public onlyOwner {
    require(data.length % 2 == 0);
    uint i = 0;
    while (i < data.length / 2) {
      bytes32 symbol = bytes32(data[i * 2]);
      uint rate = data[i * 2 + 1];
      rates[symbol] = rate;
      RateUpdated(now, symbol, rate);
      i++;
    }
  }

  /**
   * @dev Allows the anyone to read the current rate.
   * @param _symbol the symbol to be retrieved. 
   */
  function getRate(string _symbol) public constant returns(uint) {
    return rates[sha3(_symbol)];
  }

}
