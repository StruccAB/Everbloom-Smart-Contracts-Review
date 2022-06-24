import Everbloom2 from "../../contracts/Everbloom2.cdc"

// This transaction will disable a perk

transaction (perkID: UInt32) {
  let adminRef: &Everbloom2.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&Everbloom2.Admin>(from: Everbloom2.AdminStoragePath)
    ?? panic("Could not borrow admin reference")
  }

  execute {
    self.adminRef.invalidatePerk(perkID: perkID)
  }
}
