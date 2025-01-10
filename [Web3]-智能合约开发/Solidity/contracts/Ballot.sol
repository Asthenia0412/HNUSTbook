// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract Storage {
    int256 private storedValue;

    // Store a value
    function store(int256 value) public {
        storedValue = value;
    }

    // Retrieve the stored value
    function retrieve() public view returns (int256) {
        return storedValue;
    }
}
