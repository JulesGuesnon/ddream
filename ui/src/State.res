type state = {authentication: option<string>, user: option<Services.user>}

type action = Login(string, Services.user)

let subscriptions = ref(list{})

let state = ref({
  authentication: None,
  user: None,
})

let setState = newState => {
  state := newState
}

let dispatch = action => {
  switch action {
  | Login(a, u) =>
    setState({
      authentication: Some(a),
      user: Some(u),
    })
  }

  List.iter(subscription => subscription(state.contents), subscriptions.contents)
}

let subscribe = cb => {
  subscriptions := List.append(subscriptions.contents, list{cb})
}

let unsubscribe = cb => {
  subscriptions := List.filter(subscription => %raw("subscription != cb"), subscriptions.contents)
}

let useGlobalState = () => {
  let (state, setState) = React.useState(() => state.contents)

  React.useEffect0(() => {
    let cb = state => setState(_ => state)

    let () = subscribe(cb)

    Some(() => unsubscribe(cb))
  })

  (state, dispatch)
}
