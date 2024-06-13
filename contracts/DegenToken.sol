// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

    contract DegenToken is ERC20, Ownable, ERC20Burnable {
        string public Item;
    constructor(address initialOwner) Ownable(initialOwner) ERC20("Degen", "DGN") {
        _mint(msg.sender, 100);
        Item = "The store has the following redeemable items: 1. Cycle 2. Bike 3. Car ";
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
        if (itemId == 1 || itemId == 2 || itemId == 3) {
            require(balanceOf(msg.sender) >= 1, "Insufficient balance");
            _burn(msg.sender, 1);
             emit ItemRedeemed("Cycle");
        } else if (itemId == 4) {
            require(balanceOf(msg.sender) >= 3, "Insufficient balance");
            _burn(msg.sender, 3);
            emit ItemRedeemed("Bike");
        } else if (itemId == 5) {
            require(balanceOf(msg.sender) >= 5, "Insufficient balance");
            _burn(msg.sender, 5);
            emit ItemRedeemed("Car");
        }

    }

    function bonus(uint amount) external {
        require(amount > 0, "Amount must be greater than zero");

        uint bonusAmount = (amount * 10) / 100; 
        uint totalAmount = amount + bonusAmount; 

        _mint(msg.sender, totalAmount);
    }
    event ItemRedeemed(string message);
    
    function getBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }
}
