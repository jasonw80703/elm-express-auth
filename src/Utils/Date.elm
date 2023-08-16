module Utils.Date exposing (decoder)

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)



decoder : Decoder Date
decoder =
    Decode.map Date.fromIsoString Decode.string
        |> Decode.andThen
            (\result ->
                case result of
                    Ok date ->
                        Decode.succeed date

                    Err err ->
                        Decode.fail <| String.join " " [ "Bad date:", err ]
            )
