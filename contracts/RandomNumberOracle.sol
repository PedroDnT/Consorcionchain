// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RandomNumberOracle {
    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao)));
    }
}
