module Data.User exposing (User, decodeUser)

import Json.Decode as Decode exposing (Decoder)



type alias User =
    { id : String
    , name : String
    , username : String
    }


decodeUser : Decoder User
decodeUser =
    Decode.map3 User
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "username" Decode.string)