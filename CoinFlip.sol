// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // bad practice to use the carat and make the compiler version flexible.  who knows what will change in the future?

contract CoinFlip {

    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    // something like a seed for a random number generator.  it shouldn't be hard-coded here in a way that attackers can see.

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        // we take the *previous* block number
        // subtract 1
        // hash this
        // turn it into a uint256 number
        uint256 blockValue = uint256(blockhash(block.number - 1));

        // there is a problem here.  both blockhash and block are GLOBAL variables/functions
        // it is bad practice to use them when trying to generate randomness

        // simply check this is a new block
        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }

}

// the heart of the matter here is that randomness is very difficult in blockchain
// due to the deterministic, state-based nature of it.
// rather than try to do it ourselves, it's best to use external contracts from trusted sources (eg chainlink vrf coordinator)
