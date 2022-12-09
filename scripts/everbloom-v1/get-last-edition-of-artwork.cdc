import Everbloom from "../contracts/Everbloom.cdc"

// This Script returns last edition of artwork

pub fun main(userAccount: Address, galleryID: UInt32, artworkID: UInt32): UInt32 {
    let userRef = getAccount(userAccount)
        .getCapability(Everbloom.UserPublicPath)
        .borrow<&{Everbloom.UserPublic}>()
            ?? panic("Could not borrow user reference")
	let galleryRef = userRef.borrowGallery(galleryID: galleryID) ?? panic("Could not borrow gallery reference")
	let artworkRef = galleryRef.borrowArtwork(artworkID: artworkID) ?? panic("Could not borrow artwork reference")

    return artworkRef.getAllEditions().removeLast()
}
