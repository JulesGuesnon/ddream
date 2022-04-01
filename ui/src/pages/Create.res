@react.component
let make = () => {
  let (name, setName) = React.useState(() => "")
  let (_, dispatch) = State.useGlobalState()

  let (isLoading, setIsLoading) = React.useState(_ => false)

  <main className="w-full h-full flex justify-center items-center">
    <div className="flex flex-col">
      <label htmlFor="name" className="text-lg"> {"Name:"->React.string} </label>
      <input
        type_="text"
        name="name"
        className="mt-2 text-zinc-900 rounded border-[1px] border-gray-300 px-2 py-1"
        placeholder="John"
        onChange={e => {
          setName(_ => ReactEvent.Form.target(e)["value"])
        }}
      />
      <div className="mt-6 w-full">
        <Button
          disabled={Js.String.length(name) == 0}
          loading={isLoading}
          onClick={_ => {
            setIsLoading(_ => true)

            let stopLoading = _ => {
              setIsLoading(_ => false)
              Js.Promise.resolve()
            }

            let _ =
              Wallet.metamask.enable()
              |> Js.Promise.then_(_ => {
                let provider = Ethers.makeProvider(Wallet.metamask.provider)

                let signer = Ethers.Providers.getSigner(provider)

                let _ =
                  Ethers.Providers.signMessage(signer, "Hello world")
                  |> Js.Promise.then_(signature => {
                    let decoded = Ethers.Utils.splitSignature(signature)

                    let _ =
                      Ethers.Providers.getAddress(signer)
                      |> Js.Promise.then_(address => {
                        let signature = `${Js.String.sliceToEnd(
                            ~from=2,
                            decoded.r,
                          )}${Js.String.sliceToEnd(~from=2, decoded.s)}`

                        let recid = decoded.recoveryParam

                        let address = Js.String.substringToEnd(~from=2, address)
                        let token = `${address}.${string_of_int(recid)}.${signature}`

                        let _ =
                          Services.create_user(~token, ~id=address, ~name)
                          |> Js.Promise.then_(v => {
                            open Services
                            setIsLoading(_ => false)

                            switch Js.Nullable.toOption(v.data) {
                            | Some(user) => {
                                dispatch(State.Login(token, user.create_user))
                                RescriptReactRouter.push("/users")
                              }
                            | None =>
                              switch Js.Nullable.toOption(v.errors) {
                              | Some(_) => RescriptReactRouter.push("/")
                              | None => ()
                              }
                            }

                            Js.Promise.resolve()
                          })
                          |> Js.Promise.catch(stopLoading)

                        Js.Promise.resolve()
                      })
                      |> Js.Promise.catch(stopLoading)

                    Js.Promise.resolve()
                  })
                  |> Js.Promise.catch(stopLoading)

                Js.Promise.resolve()
              })
              |> Js.Promise.catch(stopLoading)
          }}>
          "Create an account"
        </Button>
      </div>
    </div>
  </main>
}
