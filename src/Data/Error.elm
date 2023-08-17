module Data.Error exposing (ApiError, apiErrorsDecoder, apiErrorToString)

import Json.Decode as Decode exposing (Decoder)



type alias ApiError =
    { message : String
    , field : Maybe String
    }


apiErrorsDecoder : Decoder (List ApiError)
apiErrorsDecoder =
    Decode.field "errors" (Decode.list apiErrorDecoder)


apiErrorDecoder : Decoder ApiError
apiErrorDecoder =
    Decode.map2 ApiError
        (Decode.field "message" Decode.string)
        (Decode.field "field" (Decode.maybe Decode.string))


apiErrorToString : ApiError -> String
apiErrorToString error =
    error.message
