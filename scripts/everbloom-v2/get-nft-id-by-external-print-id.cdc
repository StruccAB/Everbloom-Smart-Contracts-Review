import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// This scripts returns the id of the NFT in the contract using id of the Print in everboom platform

pub fun main(externalPrintID: String): UInt64? {
    return EverbloomV2.getNftIDByExternalPrintID(externalPrintID: externalPrintID)
}
