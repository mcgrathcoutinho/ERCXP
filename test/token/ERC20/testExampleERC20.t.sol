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

    // Based on my current understanding, invariant tests are tests related to a certain state that needs to be constant throughout the lifetime of a contract. They do not necessarily need to mean that the value of a state variable should remain constant but that the property of that variable with respect to some functionality is never changing. Most of these properties are covered through unit tests but as a codebase becomes complex, shifting towards the notion of invariant based testing through stateful asserts becomes crucial.

    // Tests for ERC20Metadata correctness
    function testCorrectTokenName() public {
        string memory tokenName = instance.name();
        assertEq(tokenName, "Example");
    }

    function testCorrectTokenSymbol() public {
        string memory tokenSymbol = instance.symbol();
        assertEq(tokenSymbol, "EXP");
    }

    function testCorrectTokenDecimals() public {
        uint256 decimals = instance.decimals();
        assertEq(decimals, 18);
    }

    function testSumOfBalancesIsEqualToTotalSupply() public {
        //Note we introduce alice and bob since there is no array tracking the key fields of mappings. Due to this, the invariant can only be tested if there is some form of onchain or offchain tracking implemented to track addresses. In this test, we look at how the totalSupply invariant persists even after minting and burning (provided only two entities - alice and bob exist)

        // mint tokens to alice
        instance.mintTokens(alice, 100);
        instance.mintTokens(bob, 100);

        // check total supply
        uint256 totalSupply = instance.totalSupply();
        assertEq(totalSupply, instance.balanceOf(alice) + instance.balanceOf(bob));

        // Burn bobs tokens
        instance.burnTokens(bob, 100);

        //check total supply
        uint256 newTotalSupply = instance.totalSupply();
        assertEq(newTotalSupply, instance.balanceOf(alice) + instance.balanceOf(bob));
    }

}
