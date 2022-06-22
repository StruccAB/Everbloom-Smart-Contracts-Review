import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This scripts returns the id of the arwork in the contract using id of the post in everboom platform

pub fun main(artworkID: UInt32): Everbloom2.Artwork {
    return (Everbloom2.getArtwork(artworkID: artworkID))!
}
