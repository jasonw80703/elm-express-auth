module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Data.User exposing (User, decodeUser)
import Dict
import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Route.Path
import Shared.Model
import Shared.Msg



-- FLAGS


type alias Flags =
    { token : Maybe String
    , user : Maybe User
    }


decoder : Json.Decode.Decoder Flags
decoder =
    Json.Decode.map2 Flags
        (Json.Decode.field "token" (Json.Decode.maybe Json.Decode.string))
        (Json.Decode.field "user" (Json.Decode.maybe decodeUser))



-- INIT


type alias Model =
    Shared.Model.Model


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    let
        flags : Flags
        flags =
            flagsResult
                |> Result.withDefault
                    { token = Nothing
                    , user = Nothing
                    }
    in
    ( { user = flags.user, token = flags.token }
    , Effect.none
    )



-- UPDATE


type alias Msg =
    Shared.Msg.Msg


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        Shared.Msg.SignIn { token, user } ->
            ( { model | user = Just user, token = Just token }
            , Effect.batch
                [ Effect.pushRoute
                    { path = Route.Path.Users_Id_ { id = user.id }
                    , query = Dict.empty
                    , hash = Nothing
                    }
                , Effect.saveUser { user = user }
                , Effect.saveToken { token = token }
                ]
            )

        Shared.Msg.SignOut ->
            ( { model | user = Nothing, token = Nothing }
            , Effect.batch
                [ Effect.clearUser
                , Effect.clearToken
                ]
            )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.none
