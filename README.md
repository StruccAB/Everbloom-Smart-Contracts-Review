<p align="center">
    <a href="https://everbloom.app">
        <img width="250" src="everbloom_logo.png" />
    </a>
</p>

# Everbloom-Smart-Contracts

This repository contains the smart contracts of Everbloom platform. All the contracts 
are deployed on Flow blockchain.

Everbloom is the NFT platform for the 99%, a mobile-first, one-stop shop that helps anyone create, connect, collect, and build a community around NFTs.

Everbloom was founded with the mission of enabling anyone to express themselves and monetize through creativity.


## Getting Started

1. Before you start, install the [Flow command-line interface (CLI)](https://docs.onflow.org/flow-cli).
2. Clone this repository: ```$ git clone https://github.com/StruccAB/Everbloom-Smart-Contracts-Review```
3. Change to the project directory: ```$ cd Everbloom-Smart-Contracts-Review```

## Run tests

1. Change to the tests directory: ```$ cd tests```
2. Install tests dependencies: ```$ yarn ```
3. Run the tests: ```$ yarn tests```

## How it works

### Admin
1. Deploy the contracts. Everbloom Contract Init method handles logic for creating Admin resource
2. Create a `Minter` resource and store it in account storage

### User
1. Create a `User` resource instance and store it in account storage.
2. get `Minter` capability from Admin and store it in `User` resource   
3. Create a `Gallery` resource instance and store it in `User` resource 
4. Create an `Art` and store it in `Gallery` resource
5. (Everbloom only)Create an `Edition` struct instance inside `Art` resource
6. Mint a `Print` (NFT) under an edition in an Art

### Collection Setup
1. Execute `setup-collection.cdc` transaction

## Deployment

- Testnet ```0x84d3e0bf16529c09```
- Mainnet ```0xe703f7fee6400754```

## Deployment on Emulator

1. Start the emulator: ```$ flow emulator start```
2. Deploy the contracts: ```$ flow project deploy -n emulator```
