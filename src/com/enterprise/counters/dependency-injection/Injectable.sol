// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";

abstract contract Injectable {
    function init(Injector injector) public virtual;
}
