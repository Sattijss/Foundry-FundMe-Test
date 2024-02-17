// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address user = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether; //Assigning 10 ether to user and funding 0.1 ether everytime funded nodifier runs

    function setUp() external {
        DeployFundMe DeployfundMe = new DeployFundMe();
        fundMe = DeployfundMe.run();
        vm.deal(user, STARTING_BALANCE);
    }

    function testMinimumUSD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceVersion() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
        console.log(version);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(user);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayofFunders() public {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, user);
    }

    modifier funded() {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(user);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawWithSingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        console.log(startingOwnerBalance);
        console.log(startingFundMeBalance);
        console.log(user.balance);
        console.log(address(user));
        console.log(address(fundMe));
        console.log(address(fundMe.getOwner()));

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
        //checking balance after
        console.log(endingOwnerBalance);
        console.log(endingFundMeBalance);
        console.log(user.balance);
    }

    function testWithDrawFromMultipleFunders() public funded {
        //setUp
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1; //index 0 is already funded through modifier
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //vm.prank //pretend the new address
            //vm.deal //assign initial balance to the new address
            hoax(makeAddr("i"), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
            console.log(makeAddr("i"));
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        console.log(startingOwnerBalance);
        console.log(startingFundMeBalance);

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + startingFundMeBalance ==
                fundMe.getOwner().balance
        );
    }

    function testWithDrawFromMultipleFundersCheaper() public funded {
        //setUp
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1; //index 0 is already funded through modifier
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //vm.prank //pretend the new address
            //vm.deal //assign initial balance to the new address
            hoax(makeAddr("i"), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
            console.log(makeAddr("i"));
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        console.log(startingOwnerBalance);
        console.log(startingFundMeBalance);

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        //assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + startingFundMeBalance ==
                fundMe.getOwner().balance
        );
    }
}
