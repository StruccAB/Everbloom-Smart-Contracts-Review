import EverbloomV2 from "../../../contracts/EverbloomV2.cdc"

// This transaction will create a Minter resource and will store it in admin private path

transaction () {
  let adminRef: &EverbloomV2.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&EverbloomV2.Admin>(from: EverbloomV2.AdminStoragePath)
    ?? panic("Could not borrow admin reference")

    if acct.borrow<&EverbloomV2.Minter>(from: EverbloomV2.MinterStoragePath) == nil {
      let minter <- self.adminRef.createNewMinter()

      acct.save(<-minter, to: EverbloomV2.MinterStoragePath)
      acct.link<&EverbloomV2.Minter>(EverbloomV2.MinterPrivatePath, target: EverbloomV2.MinterStoragePath)
       ?? panic ("Could not minter reference")
    }
  }
}
