module Shared.NavHeader exposing (view)

import Html exposing (Html)
import Html.Attributes as Attr



view : Html msg
view =
    Html.div
        []
        [ Html.div
            [ Attr.class "pt-3" ]
            [ Html.a
                [ Attr.style "text-decoration" "none"
                , Attr.class "m-2"
                , Attr.href "/"
                ]
                [ Html.text "Home" ]
            , Html.a
                [ Attr.style "text-decoration" "none"
                , Attr.class "m-2"
                , Attr.href "/sign-up"
                ]
                [ Html.text "Sign Up" ]
            , Html.a
                [ Attr.style "text-decoration" "none"
                , Attr.class "m-2"
                , Attr.href "/sign-in"
                ]
                [ Html.text "Login" ]
            ]
        ]
