// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract gasChallenge {
    uint256[] numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    bool public optimizationApplied = false;

    function getSumOfArray() public view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        return sum;
    }

    function notOptimizedFunction() public {
        for (uint256 i = 0; i < numbers.length; i++) {
            numbers[i] = 0;
        }
    }

    function optimizedFunction() public {
        if (!optimizationApplied) {
            assembly {
                let dataPtr := numbers.slot
                let length := sload(dataPtr)
                let sum := 0
                for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                    sum := add(sum, sload(dataPtr))
                    sstore(dataPtr, 0)
                    dataPtr := add(dataPtr, 0x20)
                }
            }
            optimizationApplied = true;
        }
    }
}
