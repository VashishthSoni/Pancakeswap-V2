// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../lib/forge-std/src/Test.sol";
import "../../lib/forge-std/src/console.sol";
import "../../src/UniswapV2/UniswapV2Swap.sol";
import "../../src/PancakeSwapV2/Swap.sol";

address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

contract PancakeV2SwapTest is Test {
    
    IWETH private weth = IWETH(WETH);
    IERC20 private usdc = IERC20(USDC);
    PancakeswapSwap private swap = new PancakeswapSwap();
    V2Swap private uniswap = new V2Swap();
    function setUp()public{}

    function testSingleHopExactAmountInPANtoPAN()public{
        weth.deposit{value:1e18}();
        weth.approve(address(swap), 1e18);

        uint usdcAmountOutMin = 1;
        uint usdcAmountOut = swap.swapSingleHopExactAmountIn(WETH, USDC, 1e18, usdcAmountOutMin);
        console.log("USDC", usdcAmountOut);
        console.log("USDC", usdcAmountOut/1e6);
        usdc.approve(address(swap),usdcAmountOut);
        uint wethOut = swap.swapSingleHopExactAmountIn(USDC, WETH, usdcAmountOut, 0);
        console.log("WETH Out",wethOut);
        console.log("WETH Out",wethOut/1e16);
        assertGe(usdcAmountOut, usdcAmountOutMin, "Amount Out < Min");
    }
    
    function testSingleHopExactAmountInPANtoUNI()public{
        weth.deposit{value:1e18}();
        weth.approve(address(swap), 1e18);

        uint usdcAmountOutMin = 1;
        uint usdcAmountOut = swap.swapSingleHopExactAmountIn(WETH, USDC, 1e18, usdcAmountOutMin);
        console.log("USDC", usdcAmountOut);
        console.log("USDC", usdcAmountOut/1e6);
        usdc.approve(address(uniswap),usdcAmountOut);
        uint wethOut = uniswap.swapSingleHopExactAmountIn(usdcAmountOut, 0, USDC, WETH);
        console.log("WETH Out",wethOut);
        console.log("WETH Out",wethOut/1e16);
        assertGe(usdcAmountOut, usdcAmountOutMin, "Amount Out < Min");
    }
    function testSingleHopExactAmountInUNItoPAN()public{
        weth.deposit{value:1e18}();
        weth.approve(address(uniswap), 1e18);

        uint usdcAmountOutMin = 1;
        uint usdcAmountOut = uniswap.swapSingleHopExactAmountIn(1e18, usdcAmountOutMin, WETH, USDC);
        console.log("USDC", usdcAmountOut);
        console.log("USDC", usdcAmountOut/1e6);
        usdc.approve(address(swap),usdcAmountOut);
        uint wethOut = swap.swapSingleHopExactAmountIn(USDC, WETH, usdcAmountOut, 0);
        console.log("WETH Out",wethOut);
        console.log("WETH Out",wethOut/1e16);
        assertGe(usdcAmountOut, usdcAmountOutMin, "Amount Out < Min");
    }

    // function testSingleHopExactAmountOut()public{
    //     weth.deposit{value:1e18}();
    //     weth.approve(address(swap),1e18);

    //     uint amountOutDesired = 1500;
    //     (uint amountUsed, uint amountOut) = swap.swapSingleHopExactAmountOut(WETH, USDC, amountOutDesired, 1e18);
    //     console.log("WETH USED ",amountUsed);
    //     console.log("WETH USED ",amountOut);
    //     assertEq(amountOutDesired, amountOut);

    // }
}