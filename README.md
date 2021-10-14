# Advance-Solidity

## Token Crowdsale 
![headline](https://user-images.githubusercontent.com/83662813/136304674-15a182a2-66b0-4598-a00b-9e931ad73017.jpg)

## Background

***My company has decided to crowdsale their PupperCoin token in order to help fund the network development.
This network will be used to track dog breeding activity across the globe in a decentralized way, and allow humans to track the genetic trail of their pets. I have already worked with the necessary legal bodies and obtained the green light on creating a crowdsale open to the public. However, I am required to enable refunds if the crowdsale is successful and the goal is met, and I am only allowed to raise a maximum of 300 ether. The crowdsale will run for 24 weeks.***

I will need to create an ERC20 token that will be minted through a **`Crowdsale`** contract that I can leverage from the OpenZeppelin Solidity library.

This crowdsale contract will manage the entire process, allowing users to send ETH and get back PUP (PupperCoin).
This contract will mint the tokens automatically and distribute them to buyers in one transaction.

It will need to inherit **`Crowdsale`**, **`CappedCrowdsale`**, **`TimedCrowdsale`**, **`RefundableCrowdsale`**, and **`MintedCrowdsale`**.

I will conduct the crowdsale on the Kovan or Ropsten testnet in order to get a real-world pre-production test in.

## Instructions

### Creating your project

Using Remix, I created a file called `PupperCoin.sol` and create a standard `ERC20Mintable` token.
![puppercoin](https://user-images.githubusercontent.com/83662813/136305106-29c89ad4-c36f-421e-ad06-28e4dece17b5.png)

I Created a new contract named `PupperCoinCrowdsale.sol`, and prepared it like a standard crowdsale.
![PuppercoinCrowdsale](https://user-images.githubusercontent.com/83662813/136308820-11aae861-7da1-411b-ba71-f4dba983ee33.gif)

### Designing the contracts

#### ERC20 PupperCoin

A simple standard `ERC20Mintable` and `ERC20Detailed` contract was used, and hardcoding `18` as the `decimals` parameter, leaving the `initial_supply` parameter alone. Hardcoding the decimals was not necessary however, since most use-cases match Ethereum's default, I can do so.

I simply needed to fill in the `PupperCoin.sol` file with this [starter code](../Starter-Code/PupperCoin.sol), which contains the complete contract that I will need to work with in the Crowdsale.

#### PupperCoinCrowdsale

I ask that you follow the instructions listed below to ensure you are able to run the steps on your own and add the token to MyCrypto, or a similar wallet. I will also
include information such as the token parameters, token name, crowdsale cap, etc. for simplicity.

Leverage the [Crowdsale](../Starter-Code/Crowdsale.sol) starter code, saving the file in Remix as `Crowdsale.sol`. This file will be used later in the process to test the `Fakenow` function, as we see below.

You will need to bootstrap the contract by inheriting the following OpenZeppelin contracts:

* `Crowdsale`

* `MintedCrowdsale`

* `CappedCrowdsale`

* `TimedCrowdsale`

* `RefundablePostDeliveryCrowdsale`

![Inherit](https://user-images.githubusercontent.com/83662813/136306431-83ae007f-8b7f-42c2-8788-56b0c8fe12a0.png)

You will need to provide parameters for all of the features of your crowdsale, such as the `name`, `symbol`, `wallet` for fundraising, `goal`, etc. Feel free to configure these parameters to your liking.
![parameters](https://user-images.githubusercontent.com/83662813/136306809-4c7508c5-1f3a-42dc-804a-d3ac83598a24.png)

You can hardcode a `rate` of 1, to maintain parity with ether units (1 TKN per Ether, or 1 TKNbit per wei). If you'd like to customize your crowdsale rate, follow the [Crowdsale Rate](https://docs.openzeppelin.com/contracts/2.x/crowdsales#crowdsale-rate) calculator on OpenZeppelin's documentation. Essentially, a token (TKN) can be divided into TKNbits just like ether can be divided into wei. When using a `rate` of 1, just like 1000000000000000000 wei is equal to 1 ether, 1000000000000000000 TKNbits is equal to 1 TKN.

![hardcode rate](https://user-images.githubusercontent.com/83662813/136307586-3cde560b-b8b3-4594-8c2c-ab19ee402b97.png)

Since `RefundablePostDeliveryCrowdsale` inherits the `RefundableCrowdsale` contract, which requires a `goal` parameter, you must call the `RefundableCrowdsale` constructor from your `PupperCoinCrowdsale` constructor, as well as the others. `RefundablePostDeliveryCrowdsale` does not have its own constructor, so just use the `RefundableCrowdsale` constructor that it inherits.

If you forget to call the `RefundableCrowdsale` constructor, the `RefundablePostDeliveryCrowdsale` will fail since it relies on it (it inherits from `RefundableCrowdsale`), and does not have its own constructor.

When passing the `open` and `close` times, use `now` and `now + 24 weeks` to set the times properly from your `PupperCoinCrowdsaleDeployer` contract.
![now ](https://user-images.githubusercontent.com/83662813/136309244-c4c6ae28-09c8-4ce6-96b3-31aaeb91499d.png)

#### PupperCoinCrowdsaleDeployer

In this contract, you will model the deployment based off of the `ArcadeTokenCrowdsaleDeployer` you built previously. Leverage the [OpenZeppelin Crowdsale Documentation](https://docs.openzeppelin.com/contracts/2.x/crowdsales) for an example of a contract deploying another, as well as the starter code provided in [Crowdsale.sol](../Starter-Code/Crowdsale.sol).
![Deployer](https://user-images.githubusercontent.com/83662813/136309899-1d9125a6-3fda-479b-b26b-d5a0e9a63985.png)

## Testing the Crowdsale which is the file with the `fakenow` function added.

Test the crowdsale by sending ether to the crowdsale from a different account (**not** the same account that is raising funds), then once you confirm that the crowdsale works as expected, try to add the token to MyCrypto and test a transaction. You can test the time functionality by replacing `now` with `fakenow`, and creating a setter function to modify `fakenow` to whatever time you want to simulate. You can also set the `close` time to be `now + 5 minutes`, or whatever timeline you'd like to test for a shorter crowdsale.

Replacing `now` with `Fakenow` and setting the `close` time to be `now + 5 minutes`. 
![Crowdsale](https://user-images.githubusercontent.com/83662813/136310660-f4aad92a-299c-40de-97ad-af841fdd8e0e.gif)

Compile Contract with the `Fakenow` function from Crowdsale.sol file
![fakenowcompile](https://user-images.githubusercontent.com/83662813/136391458-a4ea76dc-68fd-48fa-af12-e50bb6fa4166.png)

MetaMask Confirmation with `Fakenow` function from the Crowdsale.sol file.

![fakenowMeta](https://user-images.githubusercontent.com/83662813/137345432-37e7c0cd-7125-4751-9b88-4c62f2cf3889.png)

Deployed Contracts testing the `Fakenow` function from the Crowdsale.sol file.

![fakedeploy](https://user-images.githubusercontent.com/83662813/137347415-4ce7e79b-13b9-46a9-a388-6daff5ed1403.png)


Test the crowdsale by sending ether to the crowdsale from a different account

![senttokenpuppercrowdsale](https://user-images.githubusercontent.com/83662813/137350137-aab96510-2b66-4076-a1cf-d576f86bccd7.png)

![senttokenpuppercrowdsale2](https://user-images.githubusercontent.com/83662813/137350268-b0e0e08e-77a8-48a9-acff-ad30231a2957.png)

![senttokenpuppercrowdsale3](https://user-images.githubusercontent.com/83662813/137350338-1fde5131-2ed6-4474-9cb7-440c69cca02e.png)

Once you confirm that the crowdsale works as expected, try to add the token to MyCrypto and test a transaction. You can add custom tokens in MyCrypto from the `Add custom token` feature. You can also do the same for MetaMask. Make sure to purchase higher amounts of tokens in order to see the denomination appear in your wallets as more than a few wei worth.

![TokenCreation](https://user-images.githubusercontent.com/83662813/136664132-7b5ea1fd-d528-430d-a335-f2ea602a4076.gif)

When sending ether to the contract, make sure you hit the `goal` that you set, and `finalize` the sale using the `Crowdsale`'s `finalize` function. In order to finalize, `isOpen` must return false (`isOpen` comes from `TimedCrowdsale` which checks to see if the `close` time has passed yet). Since the `goal` is 300 ether, you may need to send from multiple accounts. If you run out of prefunded accounts in Ganache, you can create a new workspace.

Prefunded accounts In Ganache
![prefunded accts](https://user-images.githubusercontent.com/83662813/136312021-76b51c59-81b4-4489-a365-63e7841d87dc.png)

Sending ether to the contract, make sure you hit the `goal` that you set, and `finalize` the sale using the `Crowdsale`'s `finalize` function.

**(gif)**

Remember, the refund feature of `RefundablePostDeliveryCrowdsale` only allows for refunds once the crowdsale is closed **and** the goal is met. See the [OpenZeppelin RefundableCrowdsale](https://docs.openzeppelin.com/contracts/2.x/api/crowdsale#RefundableCrowdsale) documentation for details as to why this logic is used to prevent potential attacks on your token's value.



## Deploying the PupperCoinCrowdsale

Deploy the crowdsale to the Kovan or Ropsten testnet, and store the deployed address for later. Switch MetaMask to your desired network, and use the `Deploy` tab in Remix to deploy your contracts. Take note of the total gas cost, and compare it to how costly it would be in reality. Since you are deploying to a network that you don't have control over, faucets will not likely give out 300 test ether. You can simply reduce the goal when deploying to a testnet to a much smaller amount, like 10,000 wei.

Compiled PupperCoinCrowdsale Contracts

![compiledcrowdsale](https://user-images.githubusercontent.com/83662813/136316182-8175bbe7-3993-4e8f-b0cf-81cd68deaeda.png)

MetaMask confirmation request.

![Metamask Confirmation](https://user-images.githubusercontent.com/83662813/136316262-d309885e-e82f-466a-917c-96c18c852589.png)

Deployed PupperCoinCrowdsale Contracts to Ropsten Testnent

![Deploypuppercoin](https://user-images.githubusercontent.com/83662813/136316033-ab3d82d8-2c62-46a7-b32c-6a4155779e4f.gif)

PupperCoinCrowdsale Deployer Token address and token sale address.

![Deployertokenaddress](https://user-images.githubusercontent.com/83662813/136592970-f40bde36-d110-4d0f-a6ac-1dd36baa843e.png)

Take note of the total gas cost, and compare it to how costly it would be in reality.

**(screenshot)**

Crowdsale being tested by deploying to Ropsten testnet to a much smaller amount, like 10,000 wei because you are deploying to a network that you don't have control over, faucets will not likely give out 300 test ether.

**(gif)**
