import Everbloom2 from "../../contracts/Everbloom2.cdc"
import EverbloomMetadata from "../../contracts/EverbloomMetadata.cdc"

// This scirpts returns the MetadataViews.Display object iof the NFT metadata

pub fun main(address: Address, id: UInt64): EverbloomMetadata.PerksView {
    let account = getAccount(address)

    let collectionRef = account.getCapability(Everbloom2.CollectionPublicPath)!
        .borrow<&{Everbloom2.PrintCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    let nft = collectionRef.borrowPrint(id: id) ?? panic("Could not borrow print")
    // Get the Everbloom specific metadata for this NFT
    let view = nft.resolveView(Type<EverbloomMetadata.PerksView>())!
    let metadata = view as! EverbloomMetadata.PerksView

    return metadata
}
