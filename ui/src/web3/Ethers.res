module Providers = {
  type signer
  type t

  @send external getSigner: t => signer = "getSigner"
  @send external signMessage: (signer, string) => Js.Promise.t<string> = "signMessage"
  @send external getAddress: signer => Js.Promise.t<string> = "getAddress"
}

module Utils = {
  type signature = {
    r: string,
    s: string,
    recoveryParam: int,
  }

  @scope("utils") @module("ethers")
  external splitSignature: string => signature = "splitSignature"
}

@new @scope("providers") @module("ethers")
external makeProvider: Wallet.provider => Providers.t = "Web3Provider"
