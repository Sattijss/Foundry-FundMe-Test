// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.19;

// import {Test, console} from "forge-std/Test.sol";
// import {FundMe} from "../../src/FundMe.sol";
// import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
// import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
// import {HelperConfig} from "../../script/HelperConfig.s.sol";

// contract InteractionTest is Test {
//     FundMe fundMe;
//     HelperConfig public helperConfig;
//     //address user = makeAddr("user");
//     uint256 constant SEND_VALUE = 0.5 ether;
//     uint256 constant STARTING_BALANCE = 10 ether; //Assigning 10 ether to user and funding 0.1 ether everytime funded nodifier runs
//     uint256 public constant GAS_PRICE = 1;
//     address public constant USER = address(1);

//     function setUp() external {
//         DeployFundMe DeployfundMe = new DeployFundMe();
//         fundMe = DeployfundMe.run();
//         vm.deal(USER, STARTING_BALANCE);
//     }

//     function testUserCanFundAndOwnerWithdraw() public {
//         FundFundMe fundFundMe = new FundFundMe();
//         fundFundMe.fundFundMe(address(fundMe));

//         WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
//         withdrawFundMe.withdrawFundMe(address(fundMe));

//         assert(address(fundMe).balance == 0);
//     }
// }
