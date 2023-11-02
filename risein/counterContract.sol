// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CounterContract {
    address public owner;

    struct Counter {
        uint number;
        string description;
    }

    Counter counter;

    constructor(uint init_number, string memory init_desc) {
        owner = msg.sender;
        counter = Counter(init_number, init_desc);
    }

    modifier validator() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    function increase() external validator {
        counter.number++;
    }

    function decrease() external validator {
        counter.number--;
    }

    function current() external view returns (uint) {
        return counter.number;
    }
}
