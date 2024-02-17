// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {FundMe} from "../src/FundMe.sol";
import {PriceConverter} from "../src/PriceConverter.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address ethUSDPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundme = new FundMe(ethUSDPriceFeed);
        vm.stopBroadcast();
        return (fundme);
    }
}
