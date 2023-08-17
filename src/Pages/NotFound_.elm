module Pages.NotFound_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes as Attr
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = ExampleMsgReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ExampleMsgReplaceMe ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view _ =
    { title = "Huh?"
    , body =
        [ Html.div
            []
            [ Html.p
                []
                [ Html.text "Page not found. Let's get you back home. Click "
                , Html.span
                    []
                    [ Html.a
                        [ Attr.href "/"]
                        [ Html.text "me!" ]
                    ]
                ]
            ]
        ]
    }
