import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This scripts returns the number of NFTs in collection.

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(Everbloom2.CollectionPublicPath)!
        .borrow<&{Everbloom2.PrintCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}
