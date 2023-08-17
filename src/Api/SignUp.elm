module Api.SignUp exposing (Data, postUser)

import Effect exposing (Effect)
import Data.Error exposing (ApiError, apiErrorsDecoder)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode



type alias Data =
    { token : String
    }


decoder : Decoder Data
decoder =
    Decode.map Data
        (Decode.field "token" Decode.string)


-- TODO: create Endpoints or Api module with base URL and stuff
postUser :
    { onResponse : Result (List ApiError) Data -> msg
    , username : String
    , name : String
    , password : String
    }
    -> Effect msg
postUser options =
    let
        body : Encode.Value
        body =
            Encode.object
                [ ( "username", Encode.string options.username )
                , ( "name", Encode.string options.name )
                , ( "password", Encode.string options.password )
                ]

        cmd : Cmd msg
        cmd =
            Http.post
                { url = "http://localhost:3000/api/users/sign-up"
                , body = Http.jsonBody body
                , expect =
                    Http.expectStringResponse
                        options.onResponse
                        handleHttpResponse
                }
    in
    Effect.sendCmd cmd


handleHttpResponse : Http.Response String -> Result (List ApiError) Data
handleHttpResponse response =
    case response of
        Http.BadUrl_ _ ->
            Err
                [ { message = "Unexpected URL format"
                  , field = Nothing
                  }
                ]

        Http.Timeout_ ->
            Err
                [ { message = "Request timed out, please try again"
                  , field = Nothing
                  }
                ]

        Http.NetworkError_ ->
            Err
                [ { message = "Could not connect, please try again"
                  , field = Nothing
                  }
                ]

        Http.BadStatus_ { statusCode } body ->
            case Decode.decodeString apiErrorsDecoder body of
                Ok errors ->
                    Err errors

                Err _ ->
                    Err
                        [ { message = "Something unexpected happened" 
                          , field = Nothing
                          }
                        ]

        Http.GoodStatus_ _ body ->
            case Decode.decodeString decoder body of
                Ok data ->
                    Ok data

                Err _ ->
                    Err
                        [ { message = "Something unexpected happened"
                          , field = Nothing
                          }
                        ]
