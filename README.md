1. git clone 
2. cd into file
3. yarn install
4. yarn start
5. yarn build
6. deploy on vercel or wherever


1. link to etherscan - https://kovan.etherscan.io/address/0x85F325ae587C36D9d24F5e93Aab11e3c04712345
2. link to dapp - https://biconomy-gasless-testing-merkle-root.vercel.app/
3. link to github build - https://github.com/zysio1998/BiconomyGaslessTestingMerkleRoot

To change this to suit a specific project

1. Create a contract on remix and deploy it using the correct trsuted forwarder addresses
2. Verify the Contract
3. Change the contract address in the dapp
4. Change the ABI in the GaslessTransaction.json file

5. On the Bicnomy Dashboard 
6. Add the new contract using the contract address and the abi
7. Set it as Trusted Forwarder
8. Add an API key , and set the function to MINT nft or whatever its called
9. Add the merkle root to the contract
10. should work

https://biconomy-gasless-testing.vercel.app/



Quick Notes:
set api in biconomy dashbaord

set public active

update merkle root