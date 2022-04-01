open Lib.Graphql
open Alcotest

let test_is_auth_valid_0 () =
  Alcotest.(check bool) "Should be true" true (is_auth_valid "hello.0.world")

let test_is_auth_valid_1 () =
  Alcotest.(check bool) "Should be true" true (is_auth_valid "hello.1.world")

let test_is_auth_not_valid_0 () =
  Alcotest.(check bool) "Should be false" false (is_auth_valid "hello.1_world")

let test_is_auth_not_valid_1 () =
  Alcotest.(check bool) "Should be false" false (is_auth_valid "hello_1.world")

let test_is_auth_not_valid_2 () =
  Alcotest.(check bool) "Should be false" false (is_auth_valid "hello.7.world")

let test_split_auth () =
  Alcotest.(check (triple string int string))
    "Should get address, recid and signature" ("hello", 1, "world")
    (split_auth "hello.1.world")

let () =
  run "Graphql"
    [
      ( "Authentication",
        [
          test_case "Auth should be valid" `Quick test_is_auth_valid_0;
          test_case "Auth should be valid" `Quick test_is_auth_valid_1;
          test_case "Auth shouldn't be valid" `Quick test_is_auth_not_valid_0;
          test_case "Auth shouldn't be valid" `Quick test_is_auth_not_valid_1;
          test_case "Auth shouldn't be valid" `Quick test_is_auth_not_valid_2;
          test_case "Should split auth token" `Quick test_split_auth;
        ] );
    ]
