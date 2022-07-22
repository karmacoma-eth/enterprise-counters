// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";
import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { EnterpriseCounter } from "src/com/enterprise/counters/core/EnterpriseCounter.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract SecurityManager is Injectable {
    bytes32 public constant INCREMENTER_ROLE = keccak256("INCREMENTER_ROLE");
    bytes32 public constant DECREMENTER_ROLE = keccak256("DECREMENTER_ROLE");
    bytes32 public constant READER_ROLE = keccak256("READER_ROLE");

    function checkRole(bytes32 role, address account) public virtual returns (bool);
    function grantRole(bytes32 role, address account) public virtual returns (bool);
    function revokeRole(bytes32 role, address account) public virtual returns (bool);
}
