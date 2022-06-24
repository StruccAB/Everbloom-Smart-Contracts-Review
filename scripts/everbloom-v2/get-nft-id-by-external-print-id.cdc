import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This scripts returns the id of the NFT in the contract using id of the Print in everboom platform

pub fun main(externalPrintID: String): UInt64? {
    return Everbloom2.getNftIDByExternalPrintID(externalPrintID: externalPrintID)
}
