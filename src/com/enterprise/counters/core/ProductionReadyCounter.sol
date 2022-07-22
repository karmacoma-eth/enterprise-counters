// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { EnterpriseCounter } from "src/com/enterprise/counters/core/EnterpriseCounter.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { SecurityManager } from "src/com/enterprise/counters/security/SecurityManager.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";
import { PhoneHome } from "src/com/enterprise/counters/telemetry/PhoneHome.sol";

contract ProductionReadyCounter is EnterpriseCounter, Ownable {
    SecurityManager internal securityManager;
    Logger internal logger;
    PhoneHome internal telemetry;

    uint256 private value;

    function init(Injector injector) public override {
        securityManager = SecurityManager(injector.get("SecurityManager"));
        logger = Logger(injector.get("Logger"));
        telemetry = PhoneHome(injector.get("Telemetry"));
    }

    function increment() public override {
        require(securityManager.checkRole(securityManager.INCREMENTER_ROLE(), msg.sender));

        logger.debug("About to increment counter");

        uint256 oldValue = value;

        uint retries = 0;
        while (true) {
            uint256 newValue = oldValue + 1;
            if (newValue - oldValue == 1) {
                value = newValue;
                break;
            }

            retries++;
            logger.warn(string(abi.encodePacked("Counter increment failed, retry #", retries)));
        }

        // audit trail
        logger.info(string(abi.encodePacked(
            "Counter incremented by ", msg.sender,
            ", old value: ", oldValue,
            ", new value: ", value
        )));


    }

    function decrement() public override {
        require(securityManager.checkRole(securityManager.DECREMENTER_ROLE(), msg.sender));

        logger.debug("About to decrement counter");

        // business logic
        value--;

        logger.info(string(abi.encodePacked("Counter decremented by ", msg.sender, ", new value: ", value)));
    }

    function get() public override returns (uint256) {
        require(securityManager.checkRole(securityManager.READER_ROLE(), msg.sender));

        logger.debug("Reading counter");

        logger.info(string(abi.encodePacked("Counter read by ", msg.sender, ", value: ", value)));

        return value;
    }

    /// @dev convenience function
    function becomeRoot() public {
        transferOwnership(msg.sender);
    }
}
