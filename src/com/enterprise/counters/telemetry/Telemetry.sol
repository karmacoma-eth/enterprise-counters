// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";

abstract contract Telemetry is Injectable {
    function track(string memory eventName, string memory eventData) public virtual;
}
