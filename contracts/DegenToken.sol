// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    string public Item;
    string private lastRedeemedItem;

    constructor() ERC20("Degen", "DGN") {
        Item = "The store has the following redeemable items: 1. Cycle 2. Bike 3. Car";
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public override {
        require(balanceOf(msg.sender) >= amount, "Insufficient Balance");
        _burn(msg.sender, amount);
    }

    function buyItem(uint itemId) external {
        require(itemId >= 1 && itemId <= 5, "Invalid item ID");

        uint price;
        string memory itemName;

        if (itemId == 1 || itemId == 2 || itemId == 3) {
            price = 1;
            itemName = "Cycle";
        } else if (itemId == 4) {
            price = 3;
            itemName = "Bike";
        } else if (itemId == 5) {
            price = 5;
            itemName = "Car";
        }

        require(balanceOf(msg.sender) >= price, "Insufficient balance");
        _burn(msg.sender, price);

        lastRedeemedItem = itemName;
        emit ItemRedeemed(msg.sender, itemName);
    }

    function bonus(uint amount) external {
        require(amount > 0, "Amount must be greater than zero");

        uint bonusAmount = (amount * 10) / 100;
        uint totalAmount = amount + bonusAmount;

        _mint(msg.sender, totalAmount);
    }

    event ItemRedeemed(address indexed player, string itemName);

    function getBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function getRedeemedItems() public view returns (string memory) {
        return lastRedeemedItem;
    }
}
