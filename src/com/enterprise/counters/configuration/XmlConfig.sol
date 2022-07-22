// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { BeanListener } from "src/com/enterprise/counters/configuration/BeanListener.sol";
import { ConfigFacade } from "src/com/enterprise/counters/configuration/ConfigFacade.sol";
import { EventLogger } from "src/com/enterprise/counters/logging/EventLogger.sol";
import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";
import { XmlParser } from "src/com/enterprise/counters/xml/XmlParser.sol";
import { NoopLogger } from "src/com/enterprise/counters/logging/NoopLogger.sol";
import { NoopCounter } from "src/com/enterprise/counters/core/NoopCounter.sol";

/// @title XmlConfig
/// @author Enterprise Development Group
/// @notice With this contract, one can simply configure EnterpriseCounter with a robust XML-based configuration system.
contract XmlConfig is ConfigFacade, BeanListener {
    Injector internal injector;
    Logger logger = new EventLogger();


    function load(string memory config) public override returns(Injector) {
        injector = new Injector();

        // use a streaming parser to parse the XML config, for gas efficiency
        XmlParser xmlParser = new XmlParser();
        xmlParser.setListener(BeanListener(address(this)));
        xmlParser.parse(config);

        // TODO: hardcode the telemetry component, we're not running a charity here

        return injector;
    }

    function beanCreated(string memory beanId, string memory beanClass) public override {
        logger.info(string(abi.encodePacked("Bean created: ", beanId, " (", beanClass, ")")));

        bytes32 beanHash = keccak256(bytes(beanClass));

        if (beanHash == keccak256("NoopLogger")) {
            injector.register(beanId, address(new NoopLogger()));
        } else if (beanHash == keccak256("EventLogger")) {
            injector.register(beanId, address(new EventLogger()));
        } else if (beanHash == keccak256("NoopCounter")) {
            injector.register(beanId, address(new NoopCounter()));
        }
         else {
            logger.error(string(abi.encodePacked("Unknown bean: ", beanId, " (", beanClass, ")")));
        }
    }
}
