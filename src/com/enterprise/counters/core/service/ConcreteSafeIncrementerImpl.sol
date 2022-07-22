// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";
import { Incrementer } from "src/com/enterprise/counters/core/service/Incrementer.sol";

/// @title ConcreteSafeIncrementerImpl
/// @author Enterprise Development Group
/// @notice ConcreteSafeIncrementerImpl is an implementation of Incrementer that uses retries to safely increment
contract ConcreteSafeIncrementerImpl is Incrementer {
    uint256 internal constant EXPECTED_INCREMENT_VALUE = 1;
    Logger internal logger;

    constructor(Logger _logger) {
        logger = _logger;
    }

    function performIncrement(uint256 oldValue) public override returns (uint256) {
        uint256 retries = 0;
        uint256 newValue;

        while (true) {
            newValue = oldValue + 1;
            if (newValue - oldValue == EXPECTED_INCREMENT_VALUE) {
                break;
            }

            retries++;
            logger.warn(string(abi.encodePacked("Counter increment failed, retry #", retries)));
        }

        return newValue;
    }
}

