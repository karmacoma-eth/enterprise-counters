// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";

/// @title NoopLogger
/// @author Enterprise Development Group
contract NoopLogger is Injectable, Logger {
    function init(Injector injector) public override {}

    function debug(string memory message) public override {}
    function info(string memory message) public override {}
    function warn(string memory message) public override {}
    function error(string memory message) public override {}
}
