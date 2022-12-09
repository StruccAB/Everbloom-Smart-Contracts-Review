import Everbloom from "../contracts/Everbloom.cdc"

// This Script returns number of artworks in a gallery

pub fun main(userAccount: Address, galleryID: UInt32): Int {
    let userRef = getAccount(userAccount)
        .getCapability(Everbloom.UserPublicPath)
        .borrow<&{Everbloom.UserPublic}>()
            ?? panic("Could not borrow user reference")
	let galleryRef = userRef.borrowGallery(galleryID: galleryID) ?? panic("Could not borrow gallery reference")

    return galleryRef.getAllArtworks().length
}
