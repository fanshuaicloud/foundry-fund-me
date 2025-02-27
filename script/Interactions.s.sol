// SPXD-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(contractAddress);
        vm.stopBroadcast();
    }

    function fundFundMe(address mostRecentDeployment) public {
         vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).fund{value: 0.1 ether}();
        vm.stopBroadcast();

    }
}

contract WithdrawFundMe is Script {
    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(contractAddress);
    }

    function withdrawFundMe(address mostRecentDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).withdraw();
        vm.stopBroadcast();
    }
}
