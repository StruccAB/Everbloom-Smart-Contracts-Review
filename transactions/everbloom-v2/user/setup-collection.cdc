import Everbloom2 from "../../../contracts/Everbloom2.cdc"

// This transaction sets up an account to use Everbloom2
// by storing an empty art piece collection and creating
// a public capability for it

transaction {
    prepare(signer: AuthAccount) {
        if signer.borrow<&Everbloom2.Collection>(from: Everbloom2.CollectionStoragePath) != nil { return }
        let collection <- Everbloom2.createEmptyCollection()
        signer.save(<-collection, to: Everbloom2.CollectionStoragePath)
        signer.link<&{Everbloom2.PrintCollectionPublic}>(Everbloom2.CollectionPublicPath, target: Everbloom2.CollectionStoragePath)
    }
}
