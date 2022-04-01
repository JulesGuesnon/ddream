open Lib

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ Middlewares.cors
  @@ Dream.router
       [
         Dream.options "/graphql" (fun _ -> Dream.respond "");
         Dream.any "/graphql" (Dream.graphql Lwt.return Graphql.schema);
         Dream.get "/graphiql" (Dream.graphiql "/graphql");
       ]
