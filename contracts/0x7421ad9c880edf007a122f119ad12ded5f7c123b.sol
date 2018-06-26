
//Address: 0x7421ad9c880edf007a122f119ad12ded5f7c123b
//Contract name: TransferableMultsig
//Balance: 0 Ether
//Verification Date: 12/14/2017
//Transacion Count: 1

// CODE STARTS HERE

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/
pragma solidity 0.4.18;


/// @title Transferable Multisignature Contract
/// @author Daniel Wang - <daniel@loopring.org>.
contract TransferableMultsig {

    ////////////////////////////////////////////////////////////////////////////
    /// Variables                                                            ///
    ////////////////////////////////////////////////////////////////////////////

    uint public nonce;                  // (only) mutable state
    uint public threshold;              // immutable state
    mapping (address => bool) ownerMap; // immutable state
    address[] public owners;            // immutable state

    ////////////////////////////////////////////////////////////////////////////
    /// Constructor                                                          ///
    ////////////////////////////////////////////////////////////////////////////

    function TransferableMultsig(
        uint      _threshold,
        address[] _owners
        )
        public
    {
        updateOwners(_threshold, _owners);
    }

    ////////////////////////////////////////////////////////////////////////////
    /// Public Functions                                                     ///
    ////////////////////////////////////////////////////////////////////////////

    // default function does nothing.
    function () payable public {}

    // Note that address recovered from signatures must be strictly increasing.
    function execute(
        uint8[]   sigV,
        bytes32[] sigR,
        bytes32[] sigS,
        address   destination,
        uint      value,
        bytes     data
        )
        external
    {
        // Follows ERC191 signature scheme:
        //    https://github.com/ethereum/EIPs/issues/191
        bytes32 txHash = keccak256(
            byte(0x19),
            byte(0),
            this,
            nonce++,
            destination,
            value,
            data
        );

        verifySignatures(
            sigV,
            sigR,
            sigS,
            txHash
        );

        require(destination.call.value(value)(data));
    }

    // Note that address recovered from signatures must be strictly increasing.
    function transferOwnership(
        uint8[]   sigV,
        bytes32[] sigR,
        bytes32[] sigS,
        uint      _threshold,
        address[] _owners
        )
        external
    {
        // Follows ERC191 signature scheme:
        //    https://github.com/ethereum/EIPs/issues/191
        bytes32 txHash = keccak256(
            byte(0x19),
            byte(0),
            this,
            nonce++,
            _threshold,
            _owners
        );

        verifySignatures(
            sigV,
            sigR,
            sigS,
            txHash
        );
        updateOwners(_threshold, _owners);
    }

    ////////////////////////////////////////////////////////////////////////////
    /// Internal Functions                                                   ///
    ////////////////////////////////////////////////////////////////////////////

    function verifySignatures(
        uint8[]   sigV,
        bytes32[] sigR,
        bytes32[] sigS,
        bytes32   txHash
        )
        view
        internal
    {
        uint _threshold = threshold;
        require(_threshold == sigR.length);
        require(_threshold == sigS.length);
        require(_threshold == sigV.length);

        address lastAddr = 0x0; // cannot have 0x0 as an owner
        for (uint i = 0; i < threshold; i++) {
            address recovered = ecrecover(
                txHash,
                sigV[i],
                sigR[i],
                sigS[i]
            );

            require(recovered > lastAddr && ownerMap[recovered]);
            lastAddr = recovered;
        }
    }

    function updateOwners(
        uint      _threshold,
        address[] _owners
        )
        internal
    {
        require(_owners.length <= 10);
        require(_threshold <= _owners.length);
        require(_threshold != 0);

        // remove all current owners from ownerMap.
        address[] memory currentOwners = owners;
        for (uint i = 0; i < currentOwners.length; i++) {
            ownerMap[currentOwners[i]] = false;
        }

        address lastAddr = 0x0;
        for (i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner > lastAddr);

            ownerMap[owner] = true;
            lastAddr = owner;
        }
        owners = _owners;
        threshold = _threshold;
    }

}
