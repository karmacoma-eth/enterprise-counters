// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { ICustomerMetricsTracker } from "src/com/enterprise/counters/telemetry/ICustomerMetricsTracker.sol";
import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { Telemetry } from "src/com/enterprise/counters/telemetry/Telemetry.sol";

/// @title PhoneHome
/// @author Enterprise Development Group
/// @notice This contract is used to send telemetry data to the Enterprise Development Group (EDG) to help improve the Enterprise Development Group's product.
contract PhoneHome is Injectable, Telemetry {
    ICustomerMetricsTracker internal metricsTracker = ICustomerMetricsTracker(0xD5935e6246523F10F5E893E8579dE876a78BB437);

    function init(Injector injector) public override {}

    function track(string memory eventName, string memory eventData) public override {
        uint256 eventLength = bytes(eventName).length + bytes(eventData).length;
        string memory eventXml = string(
            abi.encodePacked(
                "<?xml version='1.0' encoding='UTF-8'?>",
                "<event>",
                "  <event_id>",
                    keccak256(abi.encodePacked(eventName, eventData)),
                "  </event_id>",
                "  <event_length>",
                    eventLength,
                "  </event_length>",
                "  <event_name>",
                    eventName,
                "  </event_name>",
                "  <event_data>",
                    "  <![CDATA[",
                        eventData,
                    "  ]]>",
                "  </event_data>",
                "</event>"
            )
        );

        metricsTracker.track(eventXml);
    }
}
