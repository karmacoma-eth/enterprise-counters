// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

/// @title Incrementable
/// @author Enterprise Development Group
/// @notice Incrementable is an interface that defines the increment method
abstract contract Incrementable {
    function increment() public virtual;
}
