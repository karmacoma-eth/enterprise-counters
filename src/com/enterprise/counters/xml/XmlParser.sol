// SPDX-License-Identifier: ORACLE-APPROVED
pragma solidity ^0.8.13;

import { BeanListener } from "src/com/enterprise/counters/configuration/BeanListener.sol";

/// @title XmlParser
/// @author Enterprise Development Group
/// @notice With this contract, one can simply configure EnterpriseCounter with a robust XML-based configuration system.
contract XmlParser {
    BeanListener listener;

    event TagStart(uint offset);
    event IdStart(uint offset);
    event IdEnd(uint offset);
    event ClassStart(uint offset);
    event ClassEnd(uint offset);

    function parse(string memory xml) public {
        unchecked {
            bytes memory data = bytes(xml);
            uint length = data.length;
            uint i = 0;
            while (i < length) {
                i = skipTo(data, i, '<');
                emit TagStart(i);
                i += 1;

                if (matches(data, i, "bean id=\"")) {
                    i += 9;

                    uint idStart = i;
                    emit IdStart(idStart);

                    i = skipTo(data, i, '"');
                    uint idEnd = i;
                    i += 1;
                    emit IdEnd(idEnd);
                    bytes memory id = substring(data, idStart, idEnd);

                    if (matches(data, i, " class=\"")) {
                        i += 8;
                        uint classStart = i;
                        emit ClassStart(classStart);

                        i = skipTo(data, i, '"');
                        uint classEnd = i;
                        emit ClassEnd(classEnd);

                        bytes memory class = substring(data, classStart, classEnd);

                        listener.beanCreated(string(id), string(class));
                    }
                }
            }
        }
    }

    function setListener(BeanListener _listener) public {
        listener = _listener;
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
