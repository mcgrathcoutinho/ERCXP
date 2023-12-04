// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {ExampleERC3156} from "../../../../../src/token/ERC20/extensions/ERC3156/ExampleERC3156.sol";

contract testExampleERC3156 is Test {

    // Instance of ExampleERC3156 contract
    ExampleERC3156 instance;

    // Sample addresses
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        instance = new ExampleERC3156("Example", "EXP");
    }

    // Minting/Burning specific tests can be found in testExampleERC20.t.sol and will not be repeated here

    // Test pausing functionality
    function testPauseSuccess() public {
        assertEq(instance.pause(), false); //Ensuring pause is false by default
        instance.setPauseStatus(true);
        assertEq(instance.pause(), true);
    }

    // Test if setters and getters for flashFee and flashReceiver works as intended
    function testFeeAndReceiverSetterGetterSuccess() public {
        instance.setFlashFee(1e18); // 1 token (1e18 since 18 decimal representation)
        instance.setFlashFeeReceiver(alice); // Sets alice as fee recipient
        assertEq(instance.flashFee(address(instance), 0), 1e18);
        assertEq(instance.flashFeeReceiver(), alice);
    }

    
}