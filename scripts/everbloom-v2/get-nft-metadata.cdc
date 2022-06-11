import EverbloomV2 from "../../contracts/EverbloomV2.cdc"
import MetadataViews from "../../contracts/MetadataViews.cdc"

pub fun main(address: Address, id: UInt64): MetadataViews.Display {
    let account = getAccount(address)

    let collectionRef = account.getCapability(EverbloomV2.CollectionPublicPath)!
        .borrow<&{EverbloomV2.PrintCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    let nft = collectionRef.borrowPrint(id: id) ?? panic("Could not borrow print")

    log (collectionRef.getIDs())
    // Get the Everbloom specific metadata for this NFT
    let view = nft.resolveView(Type<MetadataViews.Display>())!

    let metadata = view as! MetadataViews.Display

    return metadata
}
