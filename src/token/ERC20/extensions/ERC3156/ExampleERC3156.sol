// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20FlashMint, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";
import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

contract ExampleERC3156 is ERC20FlashMint {

    //Assuming team behind deployment uses multi-sig as best practice to do so
    address private multisig;

    //Address of fee recipient
    address public flashFeeReceiver;

    //Fee Amount
    uint256 public fee;

    //Pause status 
    bool public pause;

    modifier onlyAdmin() {
        if (msg.sender != multisig) revert("UnAuthorized!");
        _;
    }

    modifier whenNotPaused() {
        if (pause) revert("Contract Paused!");
        _;
    }

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        multisig = msg.sender;
    }

    //Function to pause flashLoan functionality
    function setPauseStatus(bool _pause) external onlyAdmin {
        pause = _pause;
    }

    //Exposing internal _mint() function with wrapper mintTokens() function
    function mintTokens(address _account, uint256 _amount) external onlyAdmin {
        _mint(_account, _amount);
    }

    //Exposing internal _burn() function with wrapper burnTokens() function
    function burnTokens(address _account, uint256 _amount) external onlyAdmin {
        _burn(_account, _amount);
    }

    //Returns fee recipient
    function _flashFeeReceiver() internal view override returns(address) {
        return flashFeeReceiver;
    }

    //Sets fee recipient
    function setFlashFeeReceiver(address _receiver) external onlyAdmin {
        flashFeeReceiver = _receiver;
    }

    //Returns flashFee amount
    // Note - Commenting out parameters since token and value are not used to derive fee here. Some implementations that have supply mechanisms and a system use these values to derive the fee.
    function _flashFee(address /*_token*/, uint256 /*_value)*/) internal view override returns (uint256) {
        return fee;
    }

    //Sets flashFee amount
    function setFlashFee(uint256 _fee) external onlyAdmin {
        fee = _fee;
    }

    // A good practice is to add a pause functionality as done below. This allows pausing usage of flashLoan() in case of some attacks/issues with the contract.
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 value,
        bytes calldata data
    ) public override whenNotPaused returns (bool) {
        super.flashLoan(receiver, token, value, data);
    }

}