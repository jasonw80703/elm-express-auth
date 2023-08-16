module Pages.SignIn exposing (Model, Msg, page)

import Effect exposing (Effect)
import Route exposing (Route)
import Html exposing (Html)
import Html.Events
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
    { isSubmitting : Bool
    -- errors : List String
    , password : String
    , username : String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { isSubmitting = False
      , password = ""
      , username = ""
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = UserUpdatedField Field String
    | UserSubmittedForm


type Field
    = Password
    | Username


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        UserUpdatedField Password val ->
            ( { model | password = val }
            , Effect.none
            )

        UserUpdatedField Username val ->
            ( { model | username = val }
            , Effect.none
            )

        UserSubmittedForm ->
            ( { model | isSubmitting = True }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign In"
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
                    [ Html.h1 [ Attr.class "title" ] [ Html.text "Login" ]
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
        , viewPasswordInput model
        , viewSubmitButton model
        ]


viewUsernameInput : Model -> Html Msg
viewUsernameInput model =
    Html.div
        [ Attr.class "field" ]
        [ Html.label [ Attr.class "label" ] [ Html.text "Username" ]
        , Html.div
            [ Attr.class "control" ]
            [ Html.input
                [ Attr.class "input"
                , Attr.type_ "text"
                , Attr.value model.username
                , Html.Events.onInput (UserUpdatedField Username)
                -- , TODO: Attr.value remember me
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
                , Attr.value model.password
                , Html.Events.onInput (UserUpdatedField Password)
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
                [ Attr.class "button is-link"
                , Attr.disabled model.isSubmitting
                , Attr.classList [ ( "is-loading", model.isSubmitting ) ]
                , Html.Events.onClick UserSubmittedForm
                ]
                [ Html.text "Login" ]
            ]
        ]
