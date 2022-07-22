// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

contract Injector {
    error Conflict(string name);
    error NotFound(string name);

    mapping(string => address) deps;

    function register(string memory name, address impl) public {
        if (deps[name] != address(0)) {
            revert Conflict(name);
        }

        deps[name] = impl;
    }

    function get(string memory name) public view returns (address) {
        if (deps[name] == address(0)) {
            revert NotFound(name);
        }

        return deps[name];
    }
}
