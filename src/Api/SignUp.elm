module Api.SignUp exposing (Data, Error, postUser, errorToString)

import Date exposing (Date)
import Effect exposing (Effect)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
-- import Utils.Date as Date



type alias Data =
    { name : String
    , username : String
    , createdAt : String -- TODO: Date?
    }


decoder : Decoder Data
decoder =
    Decode.map3 Data
        (Decode.field "name" Decode.string)
        (Decode.field "username" Decode.string)
        (Decode.field "createdAt" Decode.string)


type alias Error =
    { message : String
    , field : Maybe String
    }


-- TODO: create Endpoints or Api module with base URL and stuff
postUser :
    { onResponse : Result (List Error) Data -> msg
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


handleHttpResponse : Http.Response String -> Result (List Error) Data
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
            let
                a =
                    Debug.log "code" statusCode
            in
            case Decode.decodeString errorsDecoder body of
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


errorsDecoder : Decode.Decoder (List Error)
errorsDecoder =
    Decode.field "errors" (Decode.list errorDecoder)


errorDecoder : Decode.Decoder Error
errorDecoder =
    Decode.map2 Error
        (Decode.field "message" Decode.string)
        (Decode.field "field" (Decode.maybe Decode.string))


errorToString : Error -> String
errorToString error =
    error.message
