module Pages.Users.Id_ exposing (Model, Msg, page)

import Auth
import Data.User exposing (User)
import Effect exposing (Effect)
import Route exposing (Route)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
import Page exposing (Page)
import Shared
import View exposing (View)


page : Auth.User -> Shared.Model -> Route { id : String } -> Page Model Msg
page user shared route =
    Page.new
        { init = init user
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { user : User
    }


init : Auth.User -> () -> ( Model, Effect Msg )
init authUser () =
    ( { user = authUser.user }
    , Effect.none
    )



-- UPDATE


type Msg
    = ClickedSignOut


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedSignOut ->
            ( model
            , Effect.signOut
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = model.user.username
    , body =
        [ viewPage model
        ]
    }


viewPage : Model -> Html Msg
viewPage model =
    Html.div
        []
        [ Html.h1 [] [ Html.text ("Hi " ++ model.user.name) ]
        , Html.button
            [ Attr.class "button"
            , Html.Events.onClick ClickedSignOut
            ]
            [ Html.text "Sign out" ]
        ]
