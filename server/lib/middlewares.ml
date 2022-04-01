let cors next_handler req =
  Lwt.try_bind
    (fun () -> next_handler req)
    (fun response ->
      let () = Dream.set_header response "Access-Control-Allow-Origin" "*" in
      let () = Dream.set_header response "Access-Control-Allow-Headers" "*" in
      let () = Dream.set_header response "Access-Control-Allow-Method" "*" in
      Lwt.return response)
    (fun exn -> Lwt.fail exn)