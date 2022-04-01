open Lib.Signature
open Alcotest

let test_make_ethereum_message () =
  Alcotest.(check string)
    "Same string"
    "8144a6fa26be252b86456491fbcd43c1de7e022241845ffea1c3df066f7cfede"
    (make_ethereum_message "Hello world")

let test_is_address_valid () =
  Alcotest.(check bool)
    "Should be true" true
    (is_address_valid "7eCd8faDFc766f851Db6F3ef982A5857557DB140"
       ~signature:
         "d84624fee19e0aec4c18b4ce3d3a74094d4824cae195ec17bf1fb7b6faa68b602c6b6f17b614343bb49cce216409650ec6c3d5642bbc449a734833536a023041"
       ~msg:"8144a6fa26be252b86456491fbcd43c1de7e022241845ffea1c3df066f7cfede"
       ~recid:1)

let test_is_address_not_valid () =
  Alcotest.(check bool)
    "Should be false" false
    (is_address_valid "7eCd8faDFc766f851Db6F3ef982A5857557DB140"
       ~signature:
         "d84624fee19e0aec4c18b4ce3d3a74094d4824cae195ec17bf1fb7b6faa68b602c6b6f17b614343bb49cce216409650ec6c3d5642bbc449a734833536a023041"
       ~msg:"8144a6fa26be252b86456491fbcd43c1de7e022241845ffea1c3df066f7cfede"
       ~recid:0)

let test_recid_not_valid () =
  Alcotest.(check bool)
    "Should be false" false
    (is_address_valid "7eCd8faDFc766f851Db6F3ef982A5857557DB140"
       ~signature:
         "d84624fee19e0aec4c18b4ce3d3a74094d4824cae195ec17bf1fb7b6faa68b602c6b6f17b614343bb49cce216409650ec6c3d5642bbc449a734833536a023041"
       ~msg:"8144a6fa26be252b86456491fbcd43c1de7e022241845ffea1c3df066f7cfede"
       ~recid:12)

let () =
  run "Signature"
    [
      ( "Messages",
        [
          test_case "Should make the same eth message" `Quick
            test_make_ethereum_message;
        ] );
      ( "Recover",
        [
          test_case "Should have valid address" `Quick test_is_address_valid;
          test_case "Shouldn't have valid address" `Quick
            test_is_address_not_valid;
          test_case "Should return false as recid is invalid" `Quick
            test_recid_not_valid;
        ] );
    ]
