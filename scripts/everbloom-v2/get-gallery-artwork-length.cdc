import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This Script returns number of artworks in a gallery

pub fun main(userAccount: Address, galleryID: UInt32): Int {
    let userRef = getAccount(userAccount)
        .getCapability(Everbloom2.UserPublicPath)
        .borrow<&{Everbloom2.UserPublic}>()
            ?? panic("Could not borrow user reference")
	let galleryRef = userRef.borrowGallery(galleryID: galleryID) ?? panic("Could not borrow gallery reference")

    return galleryRef.getAllArtworks().length
}
