// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BattleContract {
    address public owner;
    uint256 public health = 100;
    bool public isAlive = true;
    uint256 public lastHealBlock;
    uint8 public healCooldown = 3; // Must wait 3 blocks to heal again

    constructor() {
        owner = msg.sender;
    }

    function attack(address enemyContract) public {
        require(isAlive, "You are out of the game!");
        require(enemyContract != address(0), "Invalid target!");

        BattleContract enemy = BattleContract(enemyContract);
        enemy.takeDamage();
    }

    function takeDamage() public {
        require(msg.sender != owner, "You can't attack yourself!");
        require(isAlive, "Already defeated!");

        health -= 20;
        if (health <= 0) {
            isAlive = false;
        }
    }

    function heal() public {
        require(msg.sender == owner, "Only the owner can heal!");
        require(isAlive, "You are out of the game!");
        require(
            block.number >= lastHealBlock + healCooldown,
            "Healing is on cooldown!"
        );

        health += 10;
        if (health > 100) {
            health = 100;
        }
        lastHealBlock = block.number;
    }
}
