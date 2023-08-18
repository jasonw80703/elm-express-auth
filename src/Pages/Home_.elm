module Pages.Home_ exposing (page)

import Html
import Html.Attributes as Attr
import View exposing (View)


page : View msg
page =
    { title = "App"
    , body =
        [ Html.div
            [ Attr.class "m-6" ]
            [ Html.section
                [ Attr.class "" ]
                [ Html.div
                    [ Attr.class "" ]
                    [ Html.p
                        [ Attr.class "title" ]
                        [ Html.text "App Title" ]
                    , Html.p
                        [ Attr.class "subtitle" ]
                        [ Html.text "App Subtitle" ]
                    ]
                ]
            , Html.div
                [ Attr.class "mt-2" ]
                [ Html.a
                    [ Attr.class "button is-info mr-2"
                    , Attr.href "/sign-in"
                    ]
                    [ Html.text "Login" ]
                , Html.a
                    [ Attr.class "button is-primary"
                    , Attr.href "/sign-up"
                    ]
                    [ Html.text "Sign Up" ]
                ]
            ]
        ]
    }
