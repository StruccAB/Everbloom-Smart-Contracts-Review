import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This Script returns last artwork of galleries

pub fun main(userAccount: Address, galleryID: UInt32): UInt32 {
    let userRef = getAccount(userAccount)
        .getCapability(EverbloomV2.UserPublicPath)
        .borrow<&{EverbloomV2.UserPublic}>()
            ?? panic("Could not borrow user reference")
	let galleryRef = userRef.borrowGallery(galleryID: galleryID) ?? panic("Could not borrow gallery reference")

    return galleryRef.getAllArtworks().removeLast()
}
