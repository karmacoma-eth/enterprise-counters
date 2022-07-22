// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

/// @title Incrementer
/// @author Enterprise Development Group
/// @notice Incrementer is an interface for dealing with incrementable objects
abstract contract Incrementer {
    function performIncrement(uint256) public virtual returns (uint256);
}
