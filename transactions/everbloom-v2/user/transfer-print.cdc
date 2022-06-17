import EverbloomV2 from "../../contracts/EverbloomV2.cdc"

// Transaction to transfer a print to another user collection

transaction(recipient: Address, withdrawID: UInt64) {
    prepare(signer: AuthAccount) {
        let recipient = getAccount(recipient)
        let collectionRef = signer.borrow<&EverbloomV2.Collection>(from: EverbloomV2.CollectionStoragePath)!
        let depositRef = recipient.getCapability(EverbloomV2.CollectionPublicPath).borrow<&{EverbloomV2.PrintCollectionPublic}>()
         ?? panic("cannot borrow receiver collection reference")
        let nft <- collectionRef.withdraw(withdrawID: withdrawID)
        depositRef.deposit(token: <-nft)
    }
}
