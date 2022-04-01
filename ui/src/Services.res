type user = {
  id: string,
  name: string,
}

type error = {message: string}

type response<'t> = {
  data: Js.Nullable.t<'t>,
  errors: Js.Nullable.t<list<error>>,
}

type authenticate = {authenticate: user}

let authenticate: string => Js.Promise.t<
  response<authenticate>,
> = %raw("token => fetch('http://localhost:8080/graphql', {
    method: 'POST',
    body: JSON.stringify({
        query: '{authenticate{id name}}', 
        variables: null
    }),
    headers: {
        \"Authorization\": token,
        \"Content-Type\": \"application/json\"
    }
}).then(res => res.json())")

type create_user = {create_user: user}

let create_user: (
  ~token: string,
  ~id: string,
  ~name: string,
) => Js.Promise.t<
  response<create_user>,
> = %raw("(token, id, name) => fetch('http://localhost:8080/graphql', {
    method: 'POST',
    body: JSON.stringify({
        query: `
          mutation CreateUser($id: String! $name: String!) {
            create_user(id: $id, name: $name) {
              id
              name
            }
          }
        `, 
        variables: {
          id,
          name
        }
    }),
    headers: {
        \"Authorization\": token,
        \"Content-Type\": \"application/json\"
    }
}).then(res => res.json())")

type get_users = {users: array<user>}

let get_users: (
  ~token: string,
  ~id: option<string>,
) => Js.Promise.t<
  response<get_users>,
> = %raw("(token, id) => fetch('http://localhost:8080/graphql', {
    method: 'POST',
    body: JSON.stringify({
        query: `
          query Users($id: String) {
            users(id: $id) {
              id
              name
            }
          }
        `, 
        variables: {
          id: !id ? null : id
        }
    }),
    headers: {
        \"Authorization\": token,
        \"Content-Type\": \"application/json\"
    }
}).then(res => res.json())")
