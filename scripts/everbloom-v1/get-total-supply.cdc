import Everbloom from "../contracts/Everbloom.cdc"

// This scripts returns the number of Everbloom NFTs currently in existence.

pub fun main(): UInt64 {
    return Everbloom.totalSupply
}
