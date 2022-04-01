type provider = {aze: string}

type wallet = {
  id: string,
  provider: provider,
  @meth
  enable: unit => Js.Promise.t<array<string>>,
}

@module("./wallet") external metamask: wallet = "metamask"
