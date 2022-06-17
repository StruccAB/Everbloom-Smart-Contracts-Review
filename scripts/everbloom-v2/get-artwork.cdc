import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This scripts returns the id of the arwork in the contract using id of the post in everboom platform

pub fun main(artworkID: UInt32): EverbloomV2.Artwork {
    return (EverbloomV2.getArtwork(artworkID: artworkID))!
}
