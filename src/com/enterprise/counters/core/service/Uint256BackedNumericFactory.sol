// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Incrementer } from "src/com/enterprise/counters/core/service/Incrementer.sol";
import { IncrementerFactory } from "src/com/enterprise/counters/core/service/IncrementerFactory.sol";
import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";
import { Numeric } from "src/com/enterprise/counters/core/service/Numeric.sol";
import { NumericFactory } from "src/com/enterprise/counters/core/service/NumericFactory.sol";
import { Uint256BackedNumeric } from "src/com/enterprise/counters/core/service/Uint256BackedNumeric.sol";

/// @title Uint256BackedNumericFactory
/// @author Enterprise Development Group
/// @notice Uint256BackedNumericFactory is a concrete implementation of NumericFactory that returns Uint256BackedNumeric objects
contract Uint256BackedNumericFactory is Injectable, NumericFactory {
    IncrementerFactory internal incrementerFactory;
    Logger internal logger;

    function init(Injector injector) internal override {
        incrementerFactory = IncrementerFactory(injector.getSingleton("IncrementerFactory"));
        logger = Logger(injector.getSingleton("Logger"));
    }

    function getNumeric() public override returns (Numeric) {
        logger.debug("getting incrementer from factory");
        Incrementer incrementer = incrementerFactory.getIncrementer();

        logger.debug("creating new numeric");
        return new Uint256BackedNumeric(incrementer);
    }
}
