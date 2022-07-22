// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { ConcreteSafeIncrementerImpl } from "src/com/enterprise/counters/core/service/ConcreteSafeIncrementerImpl.sol";
import { Incrementer } from "src/com/enterprise/counters/core/service/Incrementer.sol";
import { IncrementerFactory } from "src/com/enterprise/counters/core/service/IncrementerFactory.sol";
import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";

/// @title ConcreteSafeIncrementerFactory
/// @author Enterprise Development Group
/// @notice ConcreteSafeIncrementerFactory is an implementation of IncrementerFactory that provides Incrementer objects that are safe to use in concurrent contexts.
contract ConcreteSafeIncrementerFactory is IncrementerFactory {
    Logger internal logger;
    ConcreteSafeIncrementerImpl internal concreteSafeIncrementerImplSingleton;

    function init(Injector injector) internal override {
        logger = Logger(injector.getSingleton("Logger"));
        concreteSafeIncrementerImplSingleton = new ConcreteSafeIncrementerImpl(logger);
    }

    function getIncrementer() public override returns (Incrementer) {
        logger.debug("returning cached singleton incrementer");
        return concreteSafeIncrementerImplSingleton;
    }
}
