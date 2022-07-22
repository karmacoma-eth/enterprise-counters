// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";

/// @title EventLogger
/// This contract emits events for all logs
contract EventLogger is Injectable, Logger {
    event DEBUG(string message);
    event INFO(string message);
    event WARN(string message);
    event ERROR(string message);

    function init(Injector injector) public override {}

    function debug(string memory message) public override {
        emit DEBUG(message);
    }

    function info(string memory message) public override {
        emit INFO(message);
    }

    function warn(string memory message) public override {
        emit WARN(message);
    }

    function error(string memory message) public override {
        emit ERROR(message);
    }
}
