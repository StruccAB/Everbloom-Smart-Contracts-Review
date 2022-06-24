import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This Script returns last gallery id of user galleries

pub fun main(userAccount: Address): UInt32 {
    let userRef = getAccount(userAccount)
        .getCapability(Everbloom2.UserPublicPath)
        .borrow<&{Everbloom2.UserPublic}>()
            ?? panic("Could not borrow user reference")

    return userRef.getAllGalleries().removeLast()
}
