import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This Script returns number of galleries in a account

pub fun main(userAccount: Address): Int {
    let userRef = getAccount(userAccount)
        .getCapability(Everbloom2.UserPublicPath)
        .borrow<&{Everbloom2.UserPublic}>()
            ?? panic("Could not borrow user reference")

    return userRef.getAllGalleries().length
}
