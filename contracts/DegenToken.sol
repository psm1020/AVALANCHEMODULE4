// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    constructor(address initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {
        _mint(initialOwner, 1000 * 10 ** decimals()); // Initial mint for the owner
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 burn_amt) public override {
        require(balanceOf(msg.sender) >= burn_amt, "Insufficient Balance");
        _burn(msg.sender, burn_amt);
    }

    function buyItem(uint itemId) external {
        require(itemId >= 1 && itemId <= 5, "Invalid item ID");

        uint price;
        string memory itemName;

        if (itemId == 1 || itemId == 2 || itemId == 3) {
            price = 1; 
            itemName = "Cycle";
        } else if (itemId == 4) {
            price = 2;  
            itemName = "Bike";
        } else if (itemId == 5) {
            price = 5;
            itemName = "Car";
        }

        require(balanceOf(msg.sender) >= price, "Insufficient balance");

        _burn(msg.sender, price);
        emit ItemPurchased(msg.sender, itemId, itemName, price);
    }

    function bonus(uint amount) external {
        require(amount > 0, "Amount must be greater than zero");

        uint bonusAmount = (amount * 10) / 100; 
        uint totalAmount = amount + bonusAmount; 

        _mint(msg.sender, totalAmount);
    }

    function getItemName(uint itemId) public pure returns (string memory) {
        if (itemId == 1 || itemId == 2 || itemId == 3) {
            return "Cycle";
        } else if (itemId == 4) {
            return "Bike";
        } else if (itemId == 5) {
            return "Car";
        } else {
            return "Unknown";
        }
    }

    event ItemPurchased(address indexed player, uint indexed itemId, string itemName, uint price);

    function getBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }
}
