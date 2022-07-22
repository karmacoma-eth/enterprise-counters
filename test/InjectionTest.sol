// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import { EnterpriseCounter } from "src/com/enterprise/counters/core/EnterpriseCounter.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { XmlConfig } from "src/com/enterprise/counters/configuration/XmlConfig.sol";

contract InjectionTest is Test {
    XmlConfig config;

    function setUp() public {
         config = new XmlConfig();
    }

    function testConfig() public {
        string memory configXml = "<?xml version='1.0' encoding='UTF-8'?><beans><bean id=\"EnterpriseCounter\" class=\"NoopCounter\"/></beans>";
        Injector injector = config.load(configXml);
        EnterpriseCounter(injector.getSingleton("EnterpriseCounter")).increment();
    }

    function testUnknownBean() public {
        string memory configXml = "<?xml version='1.0' encoding='UTF-8'?><beans><bean id=\"whatIsThis?\" class=\"NotABean!\"/></beans>";

        vm.expectRevert(abi.encodeWithSignature("UnknownBeanClass(string)", "NotABean!"));
        config.load(configXml);
    }

    function testConflict() public {
        string memory configXml = "<?xml version='1.0' encoding='UTF-8'?><beans><bean id=\"beep\" class=\"NoopCounter\"/><bean id=\"beep\" class=\"ProductionReadyCounter\"/></beans>";

        vm.expectRevert(abi.encodeWithSignature("BeanConflict(string)", "beep"));
        config.load(configXml);
    }

    function testMissingBean() public {
        string memory configXml = "<?xml version='1.0' encoding='UTF-8'?><beans><bean id=\"beep\" class=\"NoopCounter\"/></beans>";

        Injector injector = config.load(configXml);

        vm.expectRevert(abi.encodeWithSignature("MissingBean(string)", "SecurityManager"));
        injector.getSingleton("SecurityManager");
    }
}
