// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";

abstract contract Injectable {
    bool public initialized = false;

    function init(Injector injector) internal virtual;

    function initialize(Injector injector) public {
        if (initialized) {
            return;
        }
        initialized = true;
        init(injector);
    }
}
