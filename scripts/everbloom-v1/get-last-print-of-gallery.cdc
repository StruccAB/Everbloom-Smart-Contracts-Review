import Everbloom from "../contracts/Everbloom.cdc"

// This Script returns number of last minted print id

pub fun main(userAccount: Address): UInt64 {
    let collectionRef = getAccount(userAccount)
    .getCapability(Everbloom.CollectionPublicPath)
    .borrow<&{Everbloom.PrintCollectionPublic}>()
        ?? panic("Could not borrow collection reference")

    return collectionRef.getIDs().removeLast()
}
