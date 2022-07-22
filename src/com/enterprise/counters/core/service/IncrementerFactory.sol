// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Incrementer } from "src/com/enterprise/counters/core/service/Incrementer.sol";
import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";

/// @title IncrementerFactory
/// @author Enterprise Development Group
/// @notice IncrementerFactory is an interface for providers of Incrementer objects
abstract contract IncrementerFactory is Injectable {
    function getIncrementer() public virtual returns (Incrementer);
}
