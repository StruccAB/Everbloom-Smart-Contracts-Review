import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This Script returns number of galleries in a account

pub fun main(userAccount: Address): Int {
    let userRef = getAccount(userAccount)
        .getCapability(EverbloomV2.UserPublicPath)
        .borrow<&{EverbloomV2.UserPublic}>()
            ?? panic("Could not borrow user reference")

    return userRef.getAllGalleries().length
}
