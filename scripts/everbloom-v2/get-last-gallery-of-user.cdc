import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This Script returns last gallery id of user galleries

pub fun main(userAccount: Address): UInt32 {
    let userRef = getAccount(userAccount)
        .getCapability(EverbloomV2.UserPublicPath)
        .borrow<&{EverbloomV2.UserPublic}>()
            ?? panic("Could not borrow user reference")

    return userRef.getAllGalleries().removeLast()
}
