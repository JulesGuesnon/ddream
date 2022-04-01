@react.component
let make = (~id) => {
  let (state, _) = State.useGlobalState()
  let (isLoading, setIsLoading) = React.useState(() => true)
  let (user, setUser) = React.useState(() => None)

  React.useEffect0(() => {
    if Belt.Option.isNone(state.authentication) || Belt.Option.isNone(state.user) {
      RescriptReactRouter.push("/")
    }

    let token = Belt.Option.getUnsafe(state.authentication)

    let _ = Services.get_users(~token, ~id=Some(id)) |> Js.Promise.then_(res => {
      open Services

      Js.log(res.data)

      switch Js.Nullable.toOption(res.data) {
      | Some(data) =>
        if data.users->Belt.Array.length == 1 {
          setUser(_ => data.users->Belt.Array.get(0))
        } else {
          RescriptReactRouter.push("/users")
        }
      | None => ()
      }

      setIsLoading(_ => false)

      Js.Promise.resolve()
    })

    None
  })

  <main className="w-full h-full flex justify-center items-center">
    {isLoading
      ? <Spinner size="36px" />
      : switch user {
        | Some({id, name}) =>
          <div>
            <div>
              <span className="text-gray-400 text-lg"> {"Id:"->React.string} </span>
              <span className="ml-2 text-xl"> {id->React.string} </span>
            </div>
            <div>
              <span className="text-gray-400 text-lg"> {"Name:"->React.string} </span>
              <span className="ml-2 text-xl"> {name->React.string} </span>
            </div>
          </div>
        | None => React.null
        }}
  </main>
}
