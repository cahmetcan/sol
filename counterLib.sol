// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

library Counters {
    struct Counter {
        uint256 current;
    }

    function next(Counter storage index) internal returns (uint256) {
        index.current += 1;
        return index.current;
    }

    function current(Counter storage index) internal view returns (uint256) {
        return index.current;

    }
}
