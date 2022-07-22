// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { ConfigListener } from "src/com/enterprise/counters/configuration/ConfigListener.sol";

/// @title XmlParser
/// @author Enterprise Development Group
/// @notice With this contract, one can simply configure EnterpriseCounter with a robust XML-based configuration system.
contract XmlParser {
    function parse(string memory xml, ConfigListener listener) public {
        unchecked {
            bytes memory data = bytes(xml);
            uint length = data.length;
            uint i = 0;
            while (i < length) {
                i = skipTo(data, i, '<');
                i += 1;

                if (matches(data, i, "bean id=\"")) {
                    i += 9;

                    uint idStart = i;

                    i = skipTo(data, i, '"');
                    uint idEnd = i;
                    i += 1;
                    bytes memory id = substring(data, idStart, idEnd);

                    if (matches(data, i, " class=\"")) {
                        i += 8;
                        uint classStart = i;

                        i = skipTo(data, i, '"');
                        uint classEnd = i;

                        bytes memory class = substring(data, classStart, classEnd);

                        listener.onBeanTag(string(id), string(class));
                    }
                }
            }
        }
    }

    function matches(bytes memory data, uint offset, bytes memory str) internal pure returns (bool) {
        uint j = 0;
        for (; j < str.length && offset + j < data.length; ++j) {
            if (data[offset + j] != str[j]) {
                return false;
            }
        }

        return j == str.length;
    }

    function skipTo(bytes memory str, uint offset, bytes1 c) internal pure returns (uint256) {
        uint i = offset;
        while (i < str.length && str[i] != c) {
            ++i;
        }

        return i;
    }

    function substring(bytes memory str, uint256 start, uint256 end) internal pure returns (bytes memory result) {
        uint length = end - start;
        result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = str[start + i];
        }
    }
}
