module Pages.SignUp exposing (Model, Msg, page)

import Effect exposing (Effect)
import Route exposing (Route)
import Html exposing (Html)
import Html.Extra as Html
import Html.Attributes as Attr
import Page exposing (Page)
import Shared
import Shared.NavHeader as NavHeader
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
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
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign Up"
    , body =
        [ viewPage model
        ]
    }


viewPage : Model -> Html Msg
viewPage model =
    Html.div
        []
        [ NavHeader.view
        , Html.div
            [ Attr.class "columns is-mobile is-centered" ]
            [ Html.div
                [ Attr.class "column is-narrow" ]
                [ Html.div
                    [ Attr.class "section" ]
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Sign Up" ]
                    , viewForm model
                    ]
                ]
            ]
        ]


viewForm : Model -> Html Msg
viewForm model =
    Html.form
        [ Attr.class "box" ]
        [ viewUsernameInput model
        , viewNameInput model
        , viewPasswordInput model
        , viewSubmitButton model
        ]


viewUsernameInput : Model -> Html Msg
viewUsernameInput model =
    Html.div
        [ Attr.class "field" ]
        [ Html.label [ Attr.class "label" ] [ Html.text "Username" ]
        , Html.div
            [ Attr.class "control has-icons-left has-icons-right" ]
            [ Html.input
                [ Attr.class "input"
                , Attr.type_ "text"
                , Attr.placeholder "neutron-55"
                ]
                []
            , Html.span
                [ Attr.class "icon is-small is-left" ]
                [ Html.i [ Attr.class "fas fa-user" ] [] ]
            -- , Html.span
            --     [ Attr.class "icon is-small is-right" ]
            --     [ Html.i [ Attr.class "fas fa-check" ] [] ]
                    -- |> Html.viewIf username provided
            ]
        ]


viewNameInput : Model -> Html Msg
viewNameInput model =
    Html.div
        [ Attr.class "field" ]
        [ Html.label [ Attr.class "label" ] [ Html.text "Name" ]
        , Html.div
            [ Attr.class "control" ]
            [ Html.input
                [ Attr.class "input"
                , Attr.type_ "text"
                , Attr.placeholder "Jimmy Neutron"
                ]
                []
            ]
        ]


viewPasswordInput : Model -> Html Msg
viewPasswordInput model =
    Html.div
        [ Attr.class "field" ]
        [ Html.label [ Attr.class "label" ] [ Html.text "Password" ]
        , Html.div
            [ Attr.class "control" ]
            [ Html.input
                [ Attr.class "input"
                , Attr.type_ "password"
                ]
                []
            ]
        ]


viewSubmitButton : Model -> Html Msg
viewSubmitButton model =
    Html.div
        [ Attr.class "field" ]
        [ Html.div
            [ Attr.class "control" ]
            [ Html.button
                [ Attr.class "button is-link" ]
                [ Html.text "Sign Up" ]
            ]
        ]
