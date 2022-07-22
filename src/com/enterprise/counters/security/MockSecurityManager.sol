// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { SecurityManager } from "src/com/enterprise/counters/security/SecurityManager.sol";

contract MockSecurityManager is SecurityManager {
    function init(Injector injector) public override {}

    function checkRole(bytes32, address) public pure override returns (bool) {
        return true;
    }

    function grantRole(bytes32, address) public pure override returns (bool) {
        return true;
    }

    function revokeRole(bytes32, address) public pure override returns (bool) {
        return true;
    }
}
