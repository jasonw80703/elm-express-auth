module Data.Error exposing (ApiError, apiErrorsDecoder, apiErrorToString)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required, optional)



type alias ApiError =
    { message : String
    , field : String
    }


apiErrorsDecoder : Decoder (List ApiError)
apiErrorsDecoder =
    Decode.field "errors" (Decode.list apiErrorDecoder)


apiErrorDecoder : Decoder ApiError
apiErrorDecoder =
    Decode.succeed ApiError
        |> required "message" Decode.string
        |> optional "field" Decode.string ""


apiErrorToString : ApiError -> String
apiErrorToString error =
    [ error.message
    , error.field
    ]
        |> String.concat
