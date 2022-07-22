// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injectable } from "src/com/enterprise/counters/dependency-injection/Injectable.sol";

abstract contract Logger is Injectable {
    function debug(string memory message) public virtual;
    function info(string memory message) public virtual;
    function warn(string memory message) public virtual;
    function error(string memory message) public virtual;
}
