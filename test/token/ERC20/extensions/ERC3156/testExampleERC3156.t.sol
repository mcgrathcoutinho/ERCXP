// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {ExampleERC3156} from "../../../../../src/token/ERC20/extensions/ERC3156/ExampleERC3156.sol";
import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

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

    // Test if the flash loan works as intended
    function testFlashLoanSuccess() public {
        // Set up fee and fee recipient
        instance.setFlashFee(1e18); // 1 token (1e18 since 18 decimal representation)
        instance.setFlashFeeReceiver(alice); // Sets alice as fee recipient

        assertEq(instance.balanceOf(address(this)), 0); // Assert we have no balance before flash loan i.e. no collateral to take up a loan
        instance.mintTokens(address(this), 1e18); // Provide fee amount of 1 token for the loan

        // We take up a flash loan of 10 tokens (10e18 since 10 * 1e18)
        instance.flashLoan(IERC3156FlashBorrower(address(this)), address(instance), 10e18, "");

        //After flashLoan is borrowed and paid back, we perform similar checks as done in function onFlashLoan() below to ensure the process works as intended

        // Balance should now be 0 again
        assertEq(instance.balanceOf(address(this)), 0);
        
        //Ensure max loan amount is type(uint256).max - 1e18 (since fee amount is given to fee recipient i.e. alice)
        assertEq(instance.maxFlashLoan(address(instance)), type(uint256).max - 1e18);

        // Ensure total supply is fee amount provided to alice since remaining 10e18 is burnt
        assertEq(instance.totalSupply(), 1e18);

        //Ensure alice received her fee amount
        assertEq(instance.balanceOf(alice), 1e18);
    }

    // In the parameters, token = instance, value = 10e18, fee = 1e18. The variable names could be replaced or used interchangeably in the function below but I've preferred using hardcoded values we should expect.
    function onFlashLoan(address, address token, uint256 value, uint256 fee, bytes calldata) public returns(bytes32) {
        require(msg.sender == address(instance), "UnAuthorized!");

        //Ensure we received the tokens (adding 1e18 as well since we received fees previously)
        assertEq(instance.balanceOf(address(this)), 11e18);

        //Ensure max flash loan now obtainable is lesser
        assertEq(instance.maxFlashLoan(address(instance)), type(uint256).max - instance.totalSupply());

        //Ensure total supply is now 10e18 + 1e18 = 11e18 (1e18 was previously minted to cover up fees) - same as above assert condition technically
        assertEq(instance.totalSupply(), 11e18);
        
        //Some functionality to use those tokens, maybe for arbitrage 

        //Once arbitrage is complete we proceed to return the tokens + fee
        instance.approve(address(instance), 10e18 + 1e18); // tokens loaned + fee amount

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    // Testing invariant i.e. flashLoan() function cannot be called when it is paused
    function testCannotFlashLoanOnPause() public {
        instance.setPauseStatus(true);
        vm.expectRevert("Contract Paused!");
        instance.flashLoan(IERC3156FlashBorrower(address(this)), address(instance), 10e18, "");
    }
}