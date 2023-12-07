// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC4626, IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract ExampleERC4626 is ERC4626 {

    constructor(string memory _name, string memory _symbol, IERC20 _asset) ERC4626(_asset) ERC20(_name, _symbol) {}

    // A novel fee mechanism or strategies to generate yield can be implemented. For this example, I will not be implementing one (such as ERC4626Fees) since it is not specific to the OZ contracts repository and neither is an EIP. 
}