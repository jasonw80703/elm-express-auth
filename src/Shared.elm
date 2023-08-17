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

import Dict
import Effect exposing (Effect)
import Json.Decode as Decode
import Route exposing (Route)
import Route.Path
import Shared.Model
import Shared.Msg



-- FLAGS


type alias Flags =
    { token : Maybe String
    }


decoder : Decode.Decoder Flags
decoder =
    Decode.map Flags
        (Decode.field "token" (Decode.maybe Decode.string))



-- INIT


type alias Model =
    Shared.Model.Model


init : Result Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    let
        flags : Flags
        flags =
            flagsResult
                |> Result.withDefault
                    { token = Nothing
                    }
    in
    ( { user = Nothing, token = flags.token }
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
                    { path = Route.Path.Users_Id_ { id = user.id } -- TODO get ID somewhere
                    , query = Dict.empty
                    , hash = Nothing
                    }
                , Effect.saveUser token
                ]
            )

        Shared.Msg.SignOut ->
            ( { model | user = Nothing, token = Nothing }
            , Effect.clearUser
            )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.none
