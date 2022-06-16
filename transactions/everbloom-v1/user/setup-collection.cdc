import Everbloom from "../../contracts/Everbloom.cdc"

// This transaction sets up an account to use Everbloom
// by storing an empty art piece collection and creating
// a public capability for it

transaction {
    prepare(signer: AuthAccount) {
        if signer.borrow<&Everbloom.Collection>(from: Everbloom.CollectionStoragePath) != nil { return }
        let collection <- Everbloom.createEmptyCollection()
        signer.save(<-collection, to: Everbloom.CollectionStoragePath)
        signer.link<&{Everbloom.PrintCollectionPublic}>(Everbloom.CollectionPublicPath, target: Everbloom.CollectionStoragePath)
    }
}
