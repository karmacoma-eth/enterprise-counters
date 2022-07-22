// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

/// @title BeanListener
/// A simple listener to track the lifecycle events of a bean
abstract contract BeanListener {
    function beanCreated(string memory id, string memory class) public virtual;
}
