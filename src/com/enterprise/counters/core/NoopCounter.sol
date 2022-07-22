// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { Injector } from "src/com/enterprise/counters/dependency-injection/Injector.sol";
import { EnterpriseCounter } from "src/com/enterprise/counters/core/EnterpriseCounter.sol";

contract NoopCounter is EnterpriseCounter {
    function init(Injector injector) public override {}

    function increment() public override {}

    function decrement() public override {}

    function get() public pure override returns (uint256) {
        return 0;
    }
}
