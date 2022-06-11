import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This scripts returns the number of NFTs in collection.

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(EverbloomV2.CollectionPublicPath)!
        .borrow<&{EverbloomV2.PrintCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}
