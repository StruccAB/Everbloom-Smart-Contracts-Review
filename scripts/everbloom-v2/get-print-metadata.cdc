import EverbloomV2 from "../../contracts/EverbloomV2.cdc"
import EverbloomMetadata from "../../contracts/EverbloomMetadata.cdc"

// This scirpts returns the EverbloomMetadata.EverbloomMetadataView object iof the NFT metadata

pub fun main(address: Address, id: UInt64): EverbloomMetadata.EverbloomMetadataView {
    let account = getAccount(address)

    let collectionRef = account.getCapability(EverbloomV2.CollectionPublicPath)!
        .borrow<&{EverbloomV2.PrintCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    let nft = collectionRef.borrowPrint(id: id) ?? panic("Could not borrow print")
    // Get the Everbloom specific metadata for this NFT
    let view = nft.resolveView(Type<EverbloomMetadata.EverbloomMetadataView>())!
    let metadata = view as! EverbloomMetadata.EverbloomMetadataView

    return metadata
}
