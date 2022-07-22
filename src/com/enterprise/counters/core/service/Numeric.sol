// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Incrementable } from "src/com/enterprise/counters/core/service/Incrementable.sol";
import { Decrementable } from "src/com/enterprise/counters/core/service/Decrementable.sol";

/// @title Numeric
/// @author Enterprise Development Group
/// @notice Numeric is an interface for number-like objects
abstract contract Numeric is Incrementable, Decrementable  {
    function get() public virtual returns (uint256);
}
