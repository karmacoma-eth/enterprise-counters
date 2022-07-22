// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import { EnterpriseCounter } from "src/com/enterprise/counters/core/EnterpriseCounter.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { XmlConfig } from "src/com/enterprise/counters/configuration/XmlConfig.sol";

contract IntegrationTest is Test {
    function setUp() public {}

    function testConfig() public {
        XmlConfig config = new XmlConfig();
        string memory configXml = "<?xml version='1.0' encoding='UTF-8'?><beans><bean id=\"EnterpriseCounter\" class=\"NoopCounter\"/></beans>";
        Injector injector = config.load(configXml);
        EnterpriseCounter(injector.get("EnterpriseCounter")).increment();
    }
}
