// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NewworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8 ;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCrateAnvilEthConfig();
        }
    }

    struct NewworkConfig {
        address priceFeed;
    }

    function getSepoliaEthConfig() public pure returns (NewworkConfig memory) {
        NewworkConfig memory sepoliaConfig = NewworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCrateAnvilEthConfig() public returns (NewworkConfig memory) {
        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NewworkConfig memory activeNetworkConfig = NewworkConfig({
            priceFeed: address(mockV3Aggregator)
        });
        return activeNetworkConfig;
    }
}
