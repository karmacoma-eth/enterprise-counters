// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import { EnterpriseCounter } from "src/com/enterprise/counters/core/EnterpriseCounter.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { XmlConfig } from "src/com/enterprise/counters/configuration/XmlConfig.sol";
import { SecurityManager } from "src/com/enterprise/counters/security/SecurityManager.sol";

contract IntegrationTest is Test {
    XmlConfig config;
    EnterpriseCounter counter;

    function setUp() public {
        config = new XmlConfig();

        // given a proper config
        string memory configXml = string(abi.encodePacked(
            "<?xml version='1.0' encoding='UTF-8'?>",
            "<beans>",
                "<bean id=\"EnterpriseCounter\" class=\"ProductionReadyCounter\"/>",
                "<bean id=\"SecurityManager\" class=\"StrictSecurityManager\"/>",
                "<bean id=\"Logger\" class=\"EventLogger\"/>",
            "</beans>"
        ));
        Injector injector = config.load(configXml);

        SecurityManager securityManager = SecurityManager(injector.getSingleton("SecurityManager"));
        securityManager.grantRole(securityManager.INCREMENTER_ROLE(), address(this));
        securityManager.grantRole(securityManager.READER_ROLE(), address(this));

        counter = EnterpriseCounter(injector.getSingleton("EnterpriseCounter"));
    }

    function testEndToEnd() public {
        // when our app increments
        counter.increment();
        counter.increment();

        // then we get the expected value
        assertEq(counter.get(), 2);
    }

    function testFailWhenBadActorIncrements() public {
        // when a bad actor tries to increment
        address badGuy = mkaddr("badGuy");
        vm.prank(badGuy);

        // we catch it! 👮
        counter.increment();
    }

    function mkaddr(string memory name) public returns (address addr) {
        addr = address(uint160(uint256(keccak256(bytes(name)))));
        vm.label(addr, name);
    }

}
