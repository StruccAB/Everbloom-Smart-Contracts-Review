import Everbloom2 from "../../contracts/Everbloom2.cdc"

// Transaction to transfer a print to another user collection

transaction(recipient: Address, withdrawID: UInt64) {
    prepare(signer: AuthAccount) {
        let recipient = getAccount(recipient)
        let collectionRef = signer.borrow<&Everbloom2.Collection>(from: Everbloom2.CollectionStoragePath)!
        let depositRef = recipient.getCapability(Everbloom2.CollectionPublicPath).borrow<&{Everbloom2.PrintCollectionPublic}>()
         ?? panic("cannot borrow receiver collection reference")
        let nft <- collectionRef.withdraw(withdrawID: withdrawID)
        depositRef.deposit(token: <-nft)
    }
}
