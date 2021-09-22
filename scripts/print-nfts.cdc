import Everbloom from "../contracts/Everbloom.cdc"

pub fun main(userAccount: Address) {
    let userRef = getAccount(userAccount)
    .getCapability(Everbloom.UserPublicPath)
    .borrow<&{Everbloom.UserPublic}>()
        ?? panic("Could not borrow user reference")

    log ("User Galleries: ")
    log (userRef.getAllGalleries())

    let galleryRef = userRef.borrowGallery(galleryID: userRef.getAllGalleries().removeFirst()) ?? panic("Could not borrow gallery reference")

    log ("Artworks: ")
    log (galleryRef.getAllArtworks())

    let artwork = galleryRef.borrowArtwork(artworkID: galleryRef.getAllArtworks().removeFirst()) ?? panic("Could not borrow artwork reference")

    log ("ArtworkData: ")
    log (artwork.getArtworkData())

    log ("Editions: ")
    log (artwork.getAllEditions())

    let editionID = artwork.getAllEditions().removeFirst()

    log ("Edition Data: ")
    log (artwork.getEditionData(editionID: editionID))

    log ("NFTS minted in edition")
    log (artwork.getEditionNftCount(editionID: editionID))

    let collectionRef = getAccount(userAccount)
    .getCapability(Everbloom.CollectionPublicPath)
    .borrow<&{Everbloom.PrintCollectionPublic}>()
        ?? panic("Could not borrow collection reference")

    log ("User NFTs")
    log (collectionRef.getIDs())

    log ("NFTs data")
    log ("-----------------------")
    for nftID in collectionRef.getIDs() {
        log(collectionRef.borrowPrint(id: nftID)!.data)
    }
    log ("-----------------------")
}
