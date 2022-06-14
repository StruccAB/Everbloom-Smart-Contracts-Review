import Everbloom from "../contracts/Everbloom.cdc"

// This Script returns last gallery id of user galleries

pub fun main(userAccount: Address): UInt32 {
    let userRef = getAccount(userAccount)
        .getCapability(Everbloom.UserPublicPath)
        .borrow<&{Everbloom.UserPublic}>()
            ?? panic("Could not borrow user reference")

    return userRef.getAllGalleries().removeLast()
}
