@scope("window") @val external alert: string => unit = "alert"

@react.component
let make = () => {
  let {path} = RescriptReactRouter.useUrl()
  let (state, dispatch) = State.useGlobalState()

  let (isLoading, setIsLoading) = React.useState(() => false)
  <div className="w-screen h-screen bg-zinc-900 text-white">
    <nav
      className="absolute left-0 top-0 w-full h-16 bg-zinc-900 flex justify-between items-center px-24 text-white">
      <div className="flex space-x-4 items-center h-full">
        <a
          className=Styles.link
          href="/"
          onClick={e => {
            ReactEvent.Mouse.preventDefault(e)

            RescriptReactRouter.push("/")
          }}>
          {"Home"->React.string}
        </a>
      </div>
      <div className="h-full flex items-center">
        {if Belt.Option.isSome(state.user) {
          <a
            className={`mr-4 ${Styles.link}`}
            href="/users"
            onClick={e => {
              ReactEvent.Mouse.preventDefault(e)

              RescriptReactRouter.push("/users")
            }}>
            {"Users"->React.string}
          </a>
        } else {
          <>
            <a
              className={`mr-4 ${Styles.link}`}
              href="/create"
              onClick={e => {
                ReactEvent.Mouse.preventDefault(e)

                RescriptReactRouter.push("/create")
              }}>
              {"Create account"->React.string}
            </a>
            <div className="w-24">
              <Button
                loading=isLoading
                onClick={_ => {
                  setIsLoading(_ => true)

                  let stopLoading = _e => {
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

                              let token = `${Js.String.substringToEnd(
                                  ~from=2,
                                  address,
                                )}.${string_of_int(recid)}.${signature}`

                              let _ =
                                Services.authenticate(token)
                                |> Js.Promise.then_(v => {
                                  Js.log(v)
                                  open Services
                                  setIsLoading(_ => false)

                                  switch Js.Nullable.toOption(v.data) {
                                  | Some(user) => {
                                      dispatch(State.Login(token, user.authenticate))
                                      RescriptReactRouter.push("/users")
                                    }
                                  | None =>
                                    switch Js.Nullable.toOption(v.errors) {
                                    | Some(_) => RescriptReactRouter.push("/create")
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
                "Login"
              </Button>
            </div>
          </>
        }}
      </div>
    </nav>
    {switch path {
    | list{} => <Home />
    | list{"create"} => <Create />
    | list{"users"} => <Users />
    | list{"user", id} => <User id />
    | _ => <P404 />
    }}
  </div>
}
