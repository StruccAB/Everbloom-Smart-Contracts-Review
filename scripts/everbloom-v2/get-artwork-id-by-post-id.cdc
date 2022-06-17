import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This scripts returns the id of the arwork in the contract using id of the post in everboom platform

pub fun main(externalPostID: String): UInt32? {
    return EverbloomV2.getArtworkIdByExternalPostId(externalPostID: externalPostID)
}
