// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Incrementer } from "src/com/enterprise/counters/core/service/Incrementer.sol";
import { Numeric } from "src/com/enterprise/counters/core/service/Numeric.sol";

/// @title Uint256BackedNumeric
/// @author Enterprise Development Group
/// @notice Uint256BackedNumeric is a concrete implementation of Numeric that uses a uint256 as its backing store
contract Uint256BackedNumeric is Numeric {
    uint256 internal value;
    Incrementer internal incrementer;

    constructor(Incrementer _incrementer) {
        incrementer = _incrementer;
    }

    function increment() public override {
        value = incrementer.performIncrement(value);
    }

    function decrement() public override {
        value--;
    }

    function get() public view override returns (uint256) {
        return value;
    }
}
