// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ExampleERC20} from "../../../src/token/ERC20/ExampleERC20.sol";

contract testExampleERC20 is Test {

    // Instance of ExampleERC20 contract
    ExampleERC20 instance;

    // Sample addresses
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public { 
        instance = new ExampleERC20("Example", "EXP");
    }

    /*//////////////////////////////////////////////////////////////
                            Unit Tests
    //////////////////////////////////////////////////////////////*/

    // Tests for ERC20Metadata correctness
    function testCorrectTokenName() public {
        string memory tokenName = instance.name();
        assertEq(tokenName, "Example");
    }

    function testCorrectTokenSymbol() public {
        string memory tokenSymbol = instance.symbol();
        assertEq(tokenSymbol, "EXP");
    }

    // Tests for Admin minting and burning
    function testAdminCanMint() public {
        // Admin is the owner of ExampleERC20
        instance.mintTokens(alice, 100);
        assertEq(instance.balanceOf(alice), 100);
    }

    function testAdminCanBurn() public {
        testAdminCanMint(); // Mints some tokens for alice to burn
        instance.burnTokens(alice, 100);
        assertEq(instance.balanceOf(alice), 0);
    }

    function testAliceCanTransferBob() public {
        testAdminCanMint(); //mints some tokens for alice to transfer to bob
        vm.prank(alice);
        instance.transfer(bob, 50);
        assertEq(instance.balanceOf(bob), 50);
    }

    function testAliceCanApproveBobToSpend() public {
        testAdminCanMint(); //mints some tokens for alice to approve bob to spend
        vm.prank(alice);
        instance.approve(bob, 50);
        vm.prank(bob);
        instance.transferFrom(alice, bob, 50); //bob transfers to himself
        assertEq(instance.balanceOf(bob), 50);
    }

    /*//////////////////////////////////////////////////////////////
                            Invariant Tests
    //////////////////////////////////////////////////////////////*/

    

}
