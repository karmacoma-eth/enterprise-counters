// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";
import { EventLogger } from "src/com/enterprise/counters/logging/EventLogger.sol";

contract Injector {
    error BeanConflict(string name);
    error MissingBean(string name);

    Logger logger = new EventLogger();

    mapping(string => address) deps;

    function bind(string memory name, address impl) public {
        if (deps[name] != address(0)) {
            revert BeanConflict(name);
        }

        deps[name] = impl;
    }

    function getSingleton(string memory name) public returns (address) {
        address instance = deps[name];
        if (instance == address(0)) {
            revert MissingBean(name);
        }

        Injectable asInjectable = Injectable(instance);
        if (!asInjectable.initialized()) {
            logger.debug(string(abi.encodePacked("Initializing bean id ", name)));
            asInjectable.initialize(this);
        }

        return instance;
    }
}
