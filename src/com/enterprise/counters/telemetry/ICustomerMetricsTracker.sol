// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

interface ICustomerMetricsTracker {
    function track(string memory eventXml) external;
}
