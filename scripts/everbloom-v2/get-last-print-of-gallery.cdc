import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This Script returns number of last minted print id

pub fun main(userAccount: Address): UInt64 {
    let collectionRef = getAccount(userAccount)
    .getCapability(Everbloom2.CollectionPublicPath)
    .borrow<&{Everbloom2.PrintCollectionPublic}>()
        ?? panic("Could not borrow collection reference")

    return collectionRef.getIDs().removeLast()
}
