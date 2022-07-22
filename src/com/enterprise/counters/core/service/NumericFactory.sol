// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Numeric } from "src/com/enterprise/counters/core/service/Numeric.sol";

/// @title NumericFactory
/// @author Enterprise Development Group
/// @notice NumericFactory is an interface for providers of Numeric objects
abstract contract NumericFactory {
    function getNumeric() public virtual returns (Numeric);
}
