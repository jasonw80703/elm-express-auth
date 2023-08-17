module Pages.SignIn exposing (Model, Msg, page)

import Api.Me
import Api.SignIn
import Data.Error exposing (ApiError, apiErrorToString)
import Data.User exposing (User)
import Effect exposing (Effect)
import Route exposing (Route)
import Html exposing (Html)
import Html.Events
import Html.Extra as Html
import Html.Attributes as Attr
import Http
import Page exposing (Page)
import Shared
import Shared.NavHeader as NavHeader
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init shared
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { apiErrors : List ApiError
    , isSubmitting : Bool
    -- errors : List String
    , password : String
    , username : String
    }


init : Shared.Model -> () -> ( Model, Effect Msg )
init shared () =
    ( { apiErrors = []
      , isSubmitting = False
      , password = ""
      , username = ""
      }
    , Effect.redirectToUsersIdPage shared.user
    )



-- UPDATE


type Msg
    = MeFetched String (Result Http.Error User)
    | SubmitDone (Result (List ApiError) Api.SignIn.Data)
    | SubmittedForm
    | UserUpdatedField Field String


type Field
    = Password
    | Username


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        MeFetched token (Ok user) ->
            ( { model | isSubmitting = False }
            , Effect.signIn
                { token = token
                , user = user
                }
            )

        MeFetched _ (Err _) ->
            let
                error : ApiError
                error =
                    { field = Nothing 
                    , message = "Unexpected error!"
                    }
            in
            ( { model | isSubmitting = False, apiErrors = [ error ] }
            , Effect.signOut
            )

        SubmitDone (Ok { token }) ->
            ( model
            , Api.Me.get
                { onResponse = MeFetched token
                , token = token
                }
            )

        SubmitDone (Err errors) ->
            ( { model | isSubmitting = False, apiErrors = errors }
            , Effect.none
            )

        SubmittedForm ->
            ( { model | isSubmitting = True }
            , Api.SignIn.postLogin
                { onResponse = SubmitDone
                , username = model.username
                , password = model.password
                }
            )
        
        UserUpdatedField Password val ->
            ( { model | password = val }
            , Effect.none
            )

        UserUpdatedField Username val ->
            ( { model | username = val }
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
        [ Attr.class "box"
        , Html.Events.onSubmit SubmittedForm
        ]
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
                ]
                [ Html.text "Login" ]
            ]
        ]
