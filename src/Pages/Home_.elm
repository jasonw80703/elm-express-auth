module Pages.Home_ exposing (page)

import Html
import Html.Attributes as Attr
import View exposing (View)


page : View msg
page =
    { title = "Board Game Tracker"
    , body =
        [ Html.div
            [ Attr.class "m-6" ]
            [ Html.section
                [ Attr.class "" ]
                [ Html.div
                    [ Attr.class "" ]
                    [ Html.p
                        [ Attr.class "title" ]
                        [ Html.text "Board Game Tracker" ]
                    , Html.p
                        [ Attr.class "subtitle" ]
                        [ Html.text "Track your board games with friends!" ]
                    ]
                ]
            , Html.div
                [ Attr.class "mt-3" ]
                [ Html.a
                    [ Attr.class "button is-info"
                    , Attr.href "/sign-in"
                    ]
                    [ Html.text "Login" ]
                ]
            ]
        ]
    }
