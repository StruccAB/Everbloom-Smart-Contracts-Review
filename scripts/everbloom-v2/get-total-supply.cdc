import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This scripts returns the number of EverbloomV2 NFTs currently in existence.

pub fun main(): UInt64 {
    return EverbloomV2.totalSupply
}
