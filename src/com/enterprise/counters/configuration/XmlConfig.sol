// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { ConfigFacade } from "src/com/enterprise/counters/configuration/ConfigFacade.sol";
import { ConfigListener } from "src/com/enterprise/counters/configuration/ConfigListener.sol";
import { EventLogger } from "src/com/enterprise/counters/logging/EventLogger.sol";
import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { LogForwarder } from "src/com/enterprise/counters/logging/LogForwarder.sol";
import { Logger } from "src/com/enterprise/counters/logging/Logger.sol";
import { MockSecurityManager } from "src/com/enterprise/counters/security/MockSecurityManager.sol";
import { NoopCounter } from "src/com/enterprise/counters/core/NoopCounter.sol";
import { NoopLogger } from "src/com/enterprise/counters/logging/NoopLogger.sol";
import { PhoneHome } from "src/com/enterprise/counters/telemetry/PhoneHome.sol";
import { ProductionReadyCounter } from "src/com/enterprise/counters/core/ProductionReadyCounter.sol";
import { StrictSecurityManager } from "src/com/enterprise/counters/security/StrictSecurityManager.sol";
import { XmlParser } from "src/com/enterprise/counters/xml/XmlParser.sol";

/// @title XmlConfig
/// @author Enterprise Development Group
/// @notice With this contract, one can simply configure EnterpriseCounter with a robust XML-based configuration system.
contract XmlConfig is ConfigFacade, ConfigListener {
    Injector internal injector;
    Logger logger = new EventLogger();

    error UnknownBeanClass(string beanClass);

    function load(string memory config) public override returns(Injector) {
        injector = new Injector();

        // use a streaming parser to parse the XML config, for gas efficiency
        XmlParser xmlParser = new XmlParser();
        xmlParser.parse(config, ConfigListener(address(this)));

        // TODO: hardcode the telemetry component, we're not running a charity here
        injector.bind("Telemetry", address(new PhoneHome()));
        return injector;
    }

    function onBeanTag(string memory beanId, string memory beanClass) public override {
        logger.info(string(abi.encodePacked("Binding bean id ", beanId, " to class ", beanClass)));
        injector.bind(beanId, to(beanClass));
    }

    function to(string memory beanClass) internal returns(address) {
        bytes32 beanHash = keccak256(bytes(beanClass));

        if (beanHash == keccak256("NoopLogger")) {
            return address(new NoopLogger());
        } else if (beanHash == keccak256("EventLogger")) {
            return address(new EventLogger());
        } else if (beanHash == keccak256("LogForwarder")) {
            return address(new LogForwarder());
        } else if (beanHash == keccak256("MockSecurityManager")) {
            return address(new MockSecurityManager());
        } else if (beanHash == keccak256("StrictSecurityManager")) {
            return address(new StrictSecurityManager());
        } else if (beanHash == keccak256("ProductionReadyCounter")) {
            return address(new ProductionReadyCounter());
        } else if (beanHash == keccak256("NoopCounter")) {
            return address(new NoopCounter());
        } else {
            revert UnknownBeanClass(beanClass);
        }
    }
}
