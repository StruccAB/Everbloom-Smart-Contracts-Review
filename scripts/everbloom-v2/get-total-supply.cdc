import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This scripts returns the number of Everbloom2 NFTs currently in existence.

pub fun main(): UInt64 {
    return Everbloom2.totalSupply
}
