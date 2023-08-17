module Api.Me exposing (get)

import Data.User exposing (User, decodeUser)
import Effect exposing (Effect)
import Http

get :
    { onResponse : Result Http.Error User -> msg
    , token : String
    }
    -> Effect msg
get options =
    let
        cmd : Cmd msg
        cmd =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "authorization" ("Bearer " ++ options.token)
                    ]
                , url = "http://localhost:3000/api/me"
                , body = Http.emptyBody
                , expect = Http.expectJson options.onResponse decodeUser
                , timeout = Nothing
                , tracker = Nothing
                }
    in
    Effect.sendCmd cmd
