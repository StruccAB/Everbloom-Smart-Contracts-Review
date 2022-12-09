import Everbloom from "../contracts/Everbloom.cdc"

// This Script returns number of galleries in a account

pub fun main(userAccount: Address): Int {
    let userRef = getAccount(userAccount)
        .getCapability(Everbloom.UserPublicPath)
        .borrow<&{Everbloom.UserPublic}>()
            ?? panic("Could not borrow user reference")

    return userRef.getAllGalleries().length
}
