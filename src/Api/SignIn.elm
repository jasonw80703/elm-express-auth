module Api.SignIn exposing (..)

import Effect exposing (Effect)
import Http
import Json.Decode as Decode
import Json.Encode as Encode



type alias Data =
    { token : String
    }