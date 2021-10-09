pragma solidity ^0.5.0;

import "./PupperCoin.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

/* This crowdsale contract will manage the entire process, allowing users to send ETH and get back PUP (PupperCoin).
This contract will mint the tokens automatically and distribute them to buyers in one transaction.
*/
// bootstrap the contract by inheriting the following OpenZeppelin contracts; Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsalecontracts

contract PupperCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {
    
    uint fakenow;//testing the time functionality by replacing now with fakenow
    
    constructor (
        // @TODO: Fill in the constructor parameters!
        
        uint rate, // rate in TKNbits
        
        address payable wallet, //sale beneficiary
        PupperCoin pupper_token, //name of token
        uint goal, //goal for crowdsale
        uint open,
        uint close //unit cap
    )
    
        Crowdsale(rate, wallet, pupper_token)
        CappedCrowdsale(goal)
        
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        //TimedCrowdsale(fakenow, now + 1 minutes)to set the times properly from your PupperCoinCrowdsaleDeployer contract.
        
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
        
    }
}


contract PupperCoinSaleDeployer {
    
    address public token_sale_address;
    address public token_address;
    uint fakenow = now; //test the time functionality by replacing now with fakenow
    uint rate = 1;
    
    constructor(
        
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        
         // The ETHER raised from the crowdsale will be deposited in the payable wallet.
        address payable wallet,// sale beneficiary
        uint goal
        
        
    )
        public
        
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin pupper_token = new PupperCoin(name, symbol, 0);
        token_address = address(pupper_token);
        
        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        
        PupperCoinCrowdsale token_sale = new PupperCoinCrowdsale(rate, wallet, pupper_token, goal, fakenow, now + 1 minutes);// set the close time to be now + 5 minutes, to test for a shorter crowdsale.
        token_sale_address = address (token_sale);
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        pupper_token.addMinter(token_sale_address);
        pupper_token.renounceMinter();
    }
}