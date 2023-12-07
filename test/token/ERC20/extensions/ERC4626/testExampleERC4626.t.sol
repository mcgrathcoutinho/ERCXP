// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ExampleERC4626, IERC20} from "../../../../../src/token/ERC20/extensions/ERC4626/ExampleERC4626.sol";

import {ExampleERC20} from "../../../../../src/token/ERC20/ExampleERC20.sol";

contract testExampleERC4626 is Test {

    // Instance of ExampleERC4626 contract - This is the vault or shares ERC20 token
    ExampleERC4626 instance;

    // Instance of ExampleERC20 contract - This is the asset
    ExampleERC20 asset;

    // Sample addresses
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        asset = new ExampleERC20("Example", "EXP"); // asset = EXP
        instance = new ExampleERC4626("VaultExample", "vEXP", IERC20(asset)); // vault/shares token = vEXP
    }

    function testSharesTokenSymbol() public {
        string memory sharesTokenSymbol = instance.symbol();
        assertEq(sharesTokenSymbol, "vEXP");
    }

    function testSharesTokenName() public {
        string memory sharesTokenName = instance.name();
        assertEq(sharesTokenName, "VaultExample");
    }

    function testVaultDecimals() public {
        uint256 vaultDecimals = instance.decimals();
        assertEq(vaultDecimals, 18);
    }

    function testAsset() public {
        address _asset = instance.asset();
        assertEq(_asset, address(asset));
    }

    function testDeposit() public {
        // Mint asset EXP for us to use for deposit
        asset.mintTokens(address(this), 100);

        // Approve EXP for vault to transfer
        asset.approve(address(instance), 100);

        // Call deposit() 
        instance.deposit(100, address(this));

        // Confirm we received shares and vault received assets
        assertEq(instance.balanceOf(address(this)), 100); // Should be 100 shares
        assertEq(asset.balanceOf(address(instance)), 100); // Should be 100 asset EXP
    }

    function testMint() public {
        // Mint asset EXP for us to use for deposit
        asset.mintTokens(address(this), 100);

        // Approve EXP for vault to transfer
        asset.approve(address(instance), 100); 

        // Call mint()
        instance.mint(100, address(this)); // Here we specify shares we want rather than assets

        // Confirm we received shares and vault's balance is 100
        assertEq(instance.balanceOf(address(this)), 100); // Should be 100 shares
        assertEq(asset.balanceOf(address(instance)), 100); // Should be 100 EXP 
    }

    function testWithdraw() public {
        // Deposit some assets in vault in order to withdraw
        testDeposit();

        // Call withdraw()
        instance.withdraw(100, address(this), address(this));

        // Ensure we received assets back and shares are burnt in the vault
        assertEq(asset.balanceOf(address(this)), 100); // Should receive 100 asset EXP
        assertEq(instance.totalSupply(), 0); // Since we are the only people in the vault right now, supply after burning should be 0
    }

    function testRedeem() public {
        // Deposit some assets in vault in order to withdraw
        testDeposit();

        // Call withdraw()
        instance.redeem(100, address(this), address(this)); // Mention shares to burn here instead of assets to withdraw

        // Ensure we received assets back and shares are burnt in the vault
        assertEq(asset.balanceOf(address(this)), 100); // Should receive 100 asset EXP
        assertEq(instance.totalSupply(), 0); // Since we are the only people in the vault right now, supply after burning should be 0
    }
}