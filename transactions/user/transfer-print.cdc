import Everbloom from "../../contracts/Everbloom.cdc"

// Transaction to transfer a print to another user collection

transaction(recipient: Address, withdrawID: UInt64) {
    prepare(signer: AuthAccount) {
        let recipient = getAccount(recipient)
        let collectionRef = signer.borrow<&Everbloom.Collection>(from: Everbloom.CollectionStoragePath)!
        let depositRef = recipient.getCapability(Everbloom.CollectionPublicPath).borrow<&{Everbloom.PrintCollectionPublic}>()
         ?? panic("cannot borrow receiver collection reference")
        let nft <- collectionRef.withdraw(withdrawID: withdrawID)
        depositRef.deposit(token: <-nft)
    }
}
