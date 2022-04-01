open Secp256k1

module Utils = struct
  let buffer_of_hex s =
    let { Cstruct.buffer; _ } = Cstruct.of_hex s in
    buffer

  let bytes_to_hex by =
    Bytes.fold_left
      (fun acc cha -> Printf.sprintf "%s%02x" acc (int_of_char cha))
      "" by
end

open Utils

let ctx = Context.create [Context.Sign; Context.Verify]

let address_of_pub_key pub =
  let key_bytes =
    pub
    |> Key.to_bytes ~compress:false ctx
    |> Cstruct.of_bigarray
    |> Cstruct.to_bytes in
  let hex =
    Bytes.sub key_bytes 1 (Bytes.length key_bytes - 1)
    |> Digestif.KECCAK_256.digest_bytes
    |> Digestif.KECCAK_256.to_hex in
  String.sub hex 24 (String.length hex - 24)

let make_ethereum_message msg =
  let init = msg |> Bytes.of_string in
  let prefix =
    "\x19Ethereum Signed Message:\n" ^ string_of_int @@ Bytes.length init
    |> Bytes.of_string in
  Bytes.concat Bytes.empty [prefix; init]
  |> Digestif.KECCAK_256.digest_bytes
  |> Digestif.KECCAK_256.to_hex

let recover_address ~recid ~msg signature =
  let recover = Sign.read_recoverable ctx ~recid signature |> Result.get_ok in
  match Sign.recover ctx ~signature:recover ~msg with
  | Ok pub_key -> Some (pub_key |> address_of_pub_key)
  | Error _ -> None

let is_address_valid address ~recid ~msg ~signature =
  if recid != 0 && recid != 1 then
    false
  else
    let msg = buffer_of_hex msg |> Sign.msg_of_bytes_exn in
    let signature = buffer_of_hex signature in
    match recover_address ~recid ~msg signature with
    | Some recovered ->
      String.equal
        (String.lowercase_ascii address)
        (String.lowercase_ascii recovered)
    | None -> false
