module Pages.SignUp exposing (Model, Msg, page)

import Api.Me
import Api.SignUp
import Data.Error exposing (ApiError, apiErrorToString)
import Data.User exposing (User)
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
import Html.Extra as Html
import Http
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Shared.NavHeader as NavHeader
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared _ =
    Page.new
        { init = init shared
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { apiErrors : List ApiError
    , formErrors : List String
    , isSubmitting : Bool
    , name : String
    , password : String
    , username : String
    }


init : Shared.Model -> () -> ( Model, Effect Msg )
init shared () =
    ( { apiErrors = []
      , formErrors = []
      , isSubmitting = False
      , name = ""
      , password = ""
      , username = ""
      }
    , Effect.redirectToUsersIdPage shared.user
    )



-- UPDATE


type Msg
    = MeFetched String (Result Http.Error User)
    | SubmitDone (Result (List ApiError) Api.SignUp.Data)
    | UserSubmittedForm
    | UserUpdatedField Field String


type Field
    = Name
    | Password
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
                    { field = "" 
                    , message = "User couldn't be found"
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

        UserSubmittedForm ->
            let
                validForm : Bool
                validForm =
                    model.username
                        /= ""
                        && model.name
                        /= ""
                        && model.password
                        /= ""

                newModel : Model
                newModel =
                    if validForm then
                        { model | isSubmitting = True, apiErrors = [], formErrors = [] }

                    else
                        { model | isSubmitting = False, apiErrors = [], formErrors = [ "Please fill out all fields" ] }
            in
            ( newModel
            , if validForm then
                Api.SignUp.postUser
                    { onResponse = SubmitDone
                    , username = model.username
                    , name = model.name
                    , password = model.password
                    }

              else
                Effect.none
            )

        UserUpdatedField Name val ->
            ( { model | name = val }
            , Effect.none
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
        [ Attr.class "box"
        , Html.Events.onSubmit UserSubmittedForm
        ]
        [ viewUsernameInput model
        , viewNameInput model
        , viewPasswordInput model
        , viewSubmitButton model
        , viewFormErrors model
        , viewApiErrors model
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
                , Attr.value model.username
                , Html.Events.onInput (UserUpdatedField Username)
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
                , Attr.value model.name
                , Html.Events.onInput (UserUpdatedField Name)
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
                [ Html.text "Sign Up" ]
            ]
        ]


viewFormErrors : Model -> Html Msg
viewFormErrors model =
    Html.div
        []
        [ Html.ul
            [ Attr.class "notification is-danger" ]
            (List.map
                (\error ->
                    Html.li
                        []
                        [ Html.text error ]
                )
                model.formErrors
            )
        ]
        |> Html.viewIf (List.length model.formErrors > 0)


viewApiErrors : Model -> Html Msg
viewApiErrors model =
    Html.div
        []
        [ Html.ul
            [ Attr.class "notification is-danger" ]
            (List.map viewApiError model.apiErrors)
        ]
        |> Html.viewIf (List.length model.apiErrors > 0)


viewApiError : ApiError -> Html Msg
viewApiError error =
    Html.li
        []
        [ Html.text (apiErrorToString error) ]
