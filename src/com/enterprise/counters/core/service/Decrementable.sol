
// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

/// @title Decrementable
/// @author Enterprise Development Group
/// @notice Decrementable is an interface that defines the decrement method
abstract contract Decrementable {
    function decrement() public virtual;
}
