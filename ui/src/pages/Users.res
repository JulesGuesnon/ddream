@react.component
let make = () => {
  let (state, _) = State.useGlobalState()
  let (isLoading, setIsLoading) = React.useState(() => true)
  let (users, setUsers) = React.useState(() => [])

  React.useEffect0(() => {
    if Belt.Option.isNone(state.authentication) || Belt.Option.isNone(state.user) {
      RescriptReactRouter.push("/")
    }

    let token = Belt.Option.getUnsafe(state.authentication)

    let _ = Services.get_users(~token, ~id=None) |> Js.Promise.then_(res => {
      open Services

      Js.log(res.data)

      switch Js.Nullable.toOption(res.data) {
      | Some(data) => setUsers(_ => data.users)
      | None => ()
      }

      setIsLoading(_ => false)

      Js.Promise.resolve()
    })

    None
  })

  <main className="w-full h-full flex justify-center items-center">
    <div>
      <p className="text-xl text-center">
        {`Welcome ${switch state.user {
          | Some(u) => u.name
          | None => ""
          }}, here are all the users`->React.string}
      </p>
      <ul className="mt-6">
        {isLoading
          ? <Spinner size="36px" />
          : users
            ->Belt.Array.map((user: Services.user) => {
              Js.log(user)
              <li className="text-lg">
                <a
                  className=Styles.linkPrimary
                  href={`/user/${user.id}`}
                  onClick={e => {
                    ReactEvent.Mouse.preventDefault(e)

                    RescriptReactRouter.push(`/user/${user.id}`)
                  }}>
                  {user.name->React.string}
                </a>
              </li>
            })
            ->React.array}
      </ul>
    </div>
  </main>
}
