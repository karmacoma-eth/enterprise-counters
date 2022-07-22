// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";

abstract contract EnterpriseCounter is Injectable {
    function increment() public virtual;
    function decrement() public virtual;
    function get() public virtual returns (uint256);
}
