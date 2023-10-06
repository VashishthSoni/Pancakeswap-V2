//BSC: 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73
//MAINNET : 0x1097053Fd2ea711dad45caCcc45EfF7548fCB362

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;


interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}