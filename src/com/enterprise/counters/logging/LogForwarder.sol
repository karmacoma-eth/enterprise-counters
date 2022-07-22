// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";

/// @title LogForwarder
/// This contract forwards all logs to a chain of loggers
contract LogForwarder is Injectable, Logger {
    Injector internal injector;
    Logger[] internal loggers;

    function init(Injector _injector) public override {}

    function add(Logger logger) public {
        logger.init(injector);

        loggers.push(logger);
    }

    function debug(string memory message) public override {
        for (uint256 i = 0; i < loggers.length; i++) {
            loggers[i].debug(message);
        }
    }

    function info(string memory message) public override {
        for (uint256 i = 0; i < loggers.length; i++) {
            loggers[i].info(message);
        }
    }

    function warn(string memory message) public override {
        for (uint256 i = 0; i < loggers.length; i++) {
            loggers[i].warn(message);
        }
    }

    function error(string memory message) public override {
        for (uint256 i = 0; i < loggers.length; i++) {
            loggers[i].error(message);
        }
    }
}
