import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This Script returns number of last minted print id

pub fun main(userAccount: Address): UInt64 {
    let collectionRef = getAccount(userAccount)
    .getCapability(EverbloomV2.CollectionPublicPath)
    .borrow<&{EverbloomV2.PrintCollectionPublic}>()
        ?? panic("Could not borrow collection reference")

    return collectionRef.getIDs().removeLast()
}
