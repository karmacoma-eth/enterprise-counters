// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { SecurityManager } from "src/com/enterprise/counters/security/SecurityManager.sol";

contract StrictSecurityManager is SecurityManager {
    error Unauthorized(bytes32 role, address entity);
    error UnknownRole(bytes32 role);

    mapping(address => bool) _incrementers;
    mapping(address => bool) _decrementers;
    mapping(address => bool) _readers;

    mapping(bytes32 => function(address, bool, bool) returns (bool)) roles;

    function init(Injector) internal override {
        roles[INCREMENTER_ROLE] = incrementers;
        roles[DECREMENTER_ROLE] = decrementers;
        roles[READER_ROLE] = readers;
    }

    function checkRole(bytes32 role, address entity) public override returns (bool) {
        if (roles[role](entity, false, false)) {
            return true;
        } else {
            revert Unauthorized(role, entity);
        }
    }

    function grantRole(bytes32 role, address entity) public override returns (bool) {
        return roles[role](entity, true, true);
    }

    function revokeRole(bytes32 role, address entity) public override returns (bool) {
        return roles[role](entity, true, false);
    }

    function incrementers(address entity, bool set, bool newValue) internal returns(bool) {
        if (set) {
            _incrementers[entity] = newValue;
        }

        return _incrementers[entity];
    }

    function decrementers(address entity, bool set, bool newValue) internal returns(bool) {
        if (set) {
            _decrementers[entity] = newValue;
        }

        return _decrementers[entity];
    }

    function readers(address entity, bool set, bool newValue) internal returns(bool) {
        if (set) {
            _readers[entity] = newValue;
        }

        return _readers[entity];
    }
}
