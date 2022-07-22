// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";

/// @title ConfigFacade
/// @author Enterprise Development Group
/// @notice Common interface for configuring EnterpriseCounter using industry-grade Inversion of Control (IoC) containers.
abstract contract ConfigFacade {
    function load(string memory config) public virtual returns(Injector);
}
