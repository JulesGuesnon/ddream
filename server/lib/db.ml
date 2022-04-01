module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

module User = struct
  let all =
    let query =
      R.collect T.unit T.(tup2 string string) "SELECT id, name FROM users" in
    fun (module Db : DB) ->
      let%lwt users = Db.collect_list query () in
      Caqti_lwt.or_fail users

  let get =
    let query =
      R.find_opt T.string
        T.(tup2 string string)
        "SELECT id, name FROM users WHERE id = ?" in
    fun id (module Db : DB) ->
      let%lwt user = Db.find_opt query id in
      Caqti_lwt.or_fail user

  let create =
    let query =
      R.exec
        T.(tup2 string string)
        "INSERT INTO users (id, name) VALUES ($1, $2)" in
    fun ~(id : string) ~(name : string) (module Db : DB) ->
      let%lwt unit_or_error = Db.exec query (id, name) in
      Caqti_lwt.or_fail unit_or_error
end
