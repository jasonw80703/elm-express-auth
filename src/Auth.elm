module Auth exposing (User, onPageLoad, viewLoadingPage)

import Auth.Action
import Data.User
import Dict
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


type alias User =
    { token : String
    , user : Data.User.User
    }


{-| Called before an auth-only page is loaded.
-}
onPageLoad : Shared.Model -> Route () -> Auth.Action.Action User
onPageLoad shared route =
    case Debug.log "bruH" (shared.token, shared.user) of
        (Just token, Just user) ->
            Auth.Action.loadPageWithUser
                { token = token
                , user = user
                }

        (_, _) ->
            Auth.Action.pushRoute
                { path = Route.Path.SignIn
                , query =
                    Dict.fromList
                        [ ( "from", route.url.path ) -- let's us know which page they were on before we redirect
                        ]
                , hash = Nothing
                }


{-| Renders whenever `Auth.Action.showLoadingPage` is returned from `onPageLoad`.
-}
viewLoadingPage : Shared.Model -> Route () -> View Never
viewLoadingPage shared route =
    View.fromString "Loading..."
