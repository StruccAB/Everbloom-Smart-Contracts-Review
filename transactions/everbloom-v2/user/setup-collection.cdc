import EverbloomV2 from "../../../contracts/EverbloomV2.cdc"

// This transaction sets up an account to use EverbloomV2
// by storing an empty art piece collection and creating
// a public capability for it

transaction {
    prepare(signer: AuthAccount) {
        if signer.borrow<&EverbloomV2.Collection>(from: EverbloomV2.CollectionStoragePath) != nil { return }
        let collection <- EverbloomV2.createEmptyCollection()
        signer.save(<-collection, to: EverbloomV2.CollectionStoragePath)
        signer.link<&{EverbloomV2.PrintCollectionPublic}>(EverbloomV2.CollectionPublicPath, target: EverbloomV2.CollectionStoragePath)
    }
}
