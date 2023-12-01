// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ExampleERC20 is ERC20 {

    // Owner of the contract is a multisig handled by the team using an ExampleERC20 contract
    address private multisig;

    // Modifier to restrict mint/burn functionality only to the team
    modifier onlyAdmin() {
        if (msg.sender != multisig) revert("UnAuthorized!");
        _;
    }

    // Constructor initializes ExampleERC20 contract as an ERC20 by passing _name and _symbol of the token
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        multisig = msg.sender;
    }

    // The ExampleERC20 contract inherits the ERC20 contract, which includes all it's functions as well. But there are a few things to note:
    // 1. Only the public functions are accessible
    // 2. The internal functions would need to be specifically exposed by implementing external functions in this contract
    // 3. The only internal functions that should be made external/public are the _mint() and _burn() functions. 
    // 4. Exposing the remaining internal functions depends on the use case of the ExampleERC20 being implemented by a team. 
    // 5. If the ExampleERC20 implemented by the team does not implement the correct logic, it can pose different types of security threats to users that are not intended. Thus, it is best practice to only expose the _mint() and _burn() functions. 

    // Function mintTokens() exposes the internal _mint() function
    function mintTokens(address _account, uint256 _amount) external onlyAdmin {
        _mint(_account, _amount);
        //Emit an event here if needed
    }

    // Function burnTokens() exposes the internal _burn() function
    function burnTokens(address _account, uint256 _amount) external onlyAdmin {
        _burn(_account, _amount);
        //Emit an event here if needed
    }
}

