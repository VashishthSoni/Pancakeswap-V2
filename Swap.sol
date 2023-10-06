// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interface/Router.sol";
import "../../InterFaces/IERC20.sol";
import "../../InterFaces/IWETH.sol";

contract PancakeswapSwap{
    address private constant PANCAKE_ROUTER = 0xEfF92A263d31888d860bD50809A8D171709b7b1c;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    IPancakeRouter02 private router = IPancakeRouter02(PANCAKE_ROUTER);


    function swapSingleHopExactAmountIn(
        address _tokenIn,
        address _tokenOut,
        uint amountIn,
        uint amountOutMin
    )external returns(uint){
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(_tokenIn).approve(address(router), amountIn);

        address[] memory path = new address[](2);
        path[0]=_tokenIn;
        path[1]=_tokenOut;
        uint[] memory amounts = router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, block.timestamp);
        return amounts[1];
    }

    function swapSingleHopExactAmountOut(
        address _tokenIn,
        address _tokenOut,
        uint amountOutDesired,
        uint amountInMax
    )external returns(uint,uint){
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), amountInMax);
        IERC20(_tokenIn).approve(address(router), amountInMax);

        address[] memory path = new address[](2);
        path[0]= _tokenIn;
        path[1]=_tokenOut;

        uint[] memory amounts = router.swapTokensForExactTokens(amountOutDesired, amountInMax, path, msg.sender, block.timestamp);
        
        if(amounts[0]<amountInMax){
            IERC20(_tokenIn).transfer(msg.sender, amountInMax - amounts[0]);
        }
        return (amounts[0],amounts[1]);
    }
}