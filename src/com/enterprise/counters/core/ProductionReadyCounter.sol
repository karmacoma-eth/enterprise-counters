// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Base64 } from "lib/base64/base64.sol";

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

import { EnterpriseCounter } from "src/com/enterprise/counters/core/EnterpriseCounter.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";
import { PhoneHome } from "src/com/enterprise/counters/telemetry/PhoneHome.sol";
import { SecurityManager } from "src/com/enterprise/counters/security/SecurityManager.sol";
import { Numeric } from "src/com/enterprise/counters/core/service/Numeric.sol";
import { NumericFactory } from "src/com/enterprise/counters/core/service/NumericFactory.sol";


/// @title ProductionReadyCounter
/// @author Enterprise Development Group
/// @notice Our most fully featured counter yet
contract ProductionReadyCounter is EnterpriseCounter {
    SecurityManager internal securityManager;
    Logger internal logger;
    PhoneHome internal telemetry;

    Numeric private value;

    function init(Injector injector) internal override {
        securityManager = SecurityManager(injector.getSingleton("SecurityManager"));
        logger = Logger(injector.getSingleton("Logger"));
        telemetry = PhoneHome(injector.getSingleton("Telemetry"));

        NumericFactory numericFactory = NumericFactory(injector.getSingleton("NumericFactory"));
        value = numericFactory.getNumeric();
    }

    function increment() public override {
        securityManager.checkRole(securityManager.INCREMENTER_ROLE(), msg.sender);

        logger.debug("About to increment counter");

        uint256 oldValue = value.get();
        value.increment();

        /// audit trail
        /// we use base64 encryption to avoid leaking the counter value in logs
        logger.info(string(abi.encodePacked(
            "Counter incremented by ", msg.sender,
            ", old value: ", oldValue,
            ", new value: ", Base64.encode(bytes(Strings.toString(value.get())))
        )));
    }

    function decrement() public override {
        require(securityManager.checkRole(securityManager.DECREMENTER_ROLE(), msg.sender));

        logger.debug("About to decrement counter");

        // business logic
        value.decrement();

        logger.info(string(abi.encodePacked("Counter decremented by ", msg.sender, ", new value: ", value)));
    }

    function get() public override returns (uint256) {
        require(securityManager.checkRole(securityManager.READER_ROLE(), msg.sender));

        logger.debug("Reading counter");

        logger.info(string(abi.encodePacked("Counter read by ", msg.sender, ", value: ", value)));

        return value.get();
    }
}
