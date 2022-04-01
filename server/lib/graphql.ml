let auth_msg =
  Signature.make_ethereum_message
    (match Sys.getenv_opt "ETH_MESSAGE" with
    | Some m -> m
    | None -> "Hello world")

let auth_reg = Str.regexp "^.+\\.[01]\\..+$"
let is_auth_valid auth = Str.string_match auth_reg auth 0

let split_auth auth =
  let splitted = String.split_on_char '.' auth in
  (List.nth splitted 0, int_of_string (List.nth splitted 1), List.nth splitted 2)

let auth_middle req f =
  match Dream.header req "Authorization" with
  | Some auth when is_auth_valid auth ->
    let address, recid, signature = split_auth auth in
    if Signature.is_address_valid ~recid ~signature ~msg:auth_msg address then
      let%lwt user = Dream.sql req (fun db -> Db.User.get address db) in
      match user with
      | Some u -> f u
      | None -> Lwt_result.fail "Unknown user"
    else
      Lwt_result.fail "Invalid signature"
  | Some _ -> Lwt_result.fail "Invalid Authorization"
  | None -> Lwt_result.fail "Missing Authorization"

module User = struct
  open Graphql_lwt.Schema

  type t = {
    id : string;
    name : string;
  }

  let schema =
    obj "user" ~fields:(fun _info ->
        [
          field "id" ~typ:(non_null string)
            ~args:Arg.[]
            ~resolve:(fun _info user -> user.id);
          field "name" ~typ:(non_null string)
            ~args:Arg.[]
            ~resolve:(fun _info user -> user.name);
        ])

  let queries =
    [
      io_field "users"
        ~typ:(non_null (list (non_null schema)))
        ~args:Arg.[arg "id" ~typ:string]
        ~resolve:(fun info () id ->
          auth_middle info.ctx @@ fun _ ->
          match id with
          | Some id ->
            let%lwt user = Dream.sql info.ctx (fun db -> Db.User.get id db) in
            (match user with
            | Some (id, name) -> [{ id; name }]
            | None -> [])
            |> Io.return
            |> Lwt_result.ok
          | None ->
            let%lwt raw_users = Dream.sql info.ctx (fun db -> Db.User.all db) in
            raw_users
            |> List.map (fun (id, name) -> { id; name })
            |> Io.return
            |> Lwt_result.ok);
      io_field "authenticate" ~typ:(non_null schema)
        ~args:Arg.[]
        ~resolve:(fun info () ->
          auth_middle info.ctx @@ fun (id, name) ->
          { id; name } |> Io.return |> Lwt_result.ok);
    ]

  let mutations =
    [
      io_field "create_user" ~typ:(non_null schema)
        ~args:
          Arg.
            [arg "id" ~typ:(non_null string); arg "name" ~typ:(non_null string)]
        ~resolve:(fun info () id name ->
          Lwt.try_bind
            (fun () ->
              Dream.sql info.ctx (fun db -> Db.User.create ~id ~name db))
            (fun () -> { id; name } |> Io.return |> Lwt_result.ok)
            (fun _ -> "Invalid id" |> Lwt_result.fail));
    ]
end

let schema : Dream.request Graphql_lwt.Schema.schema =
  Graphql_lwt.Schema.schema ~mutations:User.mutations User.queries
