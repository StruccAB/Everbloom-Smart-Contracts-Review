import Everbloom from "../contracts/Everbloom.cdc"

// This scripts returns the number of NFTs in collection.

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(Everbloom.CollectionPublicPath)!
        .borrow<&{Everbloom.PrintCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}
