module Views.InteractablesList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div [ class "list-group mb-2" ]
        [ collapsed "umbrella"
        , active "note"
        , collapsed "red marble"
        , collapsed "green marble"
        ]


button : String -> Maybe String -> Maybe String -> Html msg
button style icon_ text_ =
    case ( icon_, text_ ) of
        ( Nothing, Nothing ) ->
            text ""

        ( Just icon_, Nothing ) ->
            Html.button [ class <| "btn btn-" ++ style ++ " btn-sm" ] [ icon icon_ ]

        ( Nothing, Just text_ ) ->
            Html.button [ class <| "btn btn-" ++ style ++ " btn-sm" ] [ text text_ ]

        ( Just icon_, Just text_ ) ->
            Html.button [ class <| "btn btn-" ++ style ++ " btn-sm" ] [ span [ class "mr-2" ] [ icon icon_ ], text text_ ]


deleteButton : Html msg
deleteButton =
    button "danger" (Just "trash") Nothing


icon : String -> Html msg
icon name =
    small [ class <| "oi oi-" ++ name ] []


collapsed : String -> Html msg
collapsed name =
    a [ href "#", class "list-group-item list-group-item-action d-flex align-items-center" ]
        [ span [ class "mr-2" ] [ icon "briefcase" ]
        , span [ class "mr-auto" ] [ text name ]
        , deleteButton
        ]


active : String -> Html msg
active name =
    Html.form [ class "list-group-item list-group-item-success" ]
        [ h4 []
            [ span [ class "mr-2" ] [ icon "briefcase" ]
            , text "Edit item"
            , span [ class "float-right" ] [ button "light" (Just "minus") Nothing ]
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Display name" ]
            , input [ class "form-control", value name ] []
            ]
        , label [] [ text "Rules" ]
        , div [ class "list-group mb-2" ]
            [ ruleCollapsed "description"
            , ruleActive "take it"
            , ruleCollapsed "give to harry"
            , ruleCollapsed "hide from harry"
            ]
        , button "primary" (Just "plus") (Just "add rule")
        ]


ruleCollapsed : String -> Html msg
ruleCollapsed summary =
    a [ href "#", class "list-group-item list-group-item-action" ] [ span [ class "mr-2" ] [ icon "bolt" ], text summary ]


ruleActive : String -> Html msg
ruleActive summary =
    div [ class "list-group-item list-group-item-warning" ]
        [ h4 [] [ span [ class "mr-2" ] [ icon "bolt" ], text "Edit rule", span [ class "float-right" ] [ button "light" (Just "minus") Nothing ] ]
        , div [ class "form-group" ]
            [ label [] [ text "Summary" ]
            , input [ class "form-control", value summary ] []
            , small [ class "form-text text-muted" ] [ text "The summary is only to help you organize your rules and is not used by the engine." ]
            ]
        , label [] [ text "Conditions" ]
        , ul []
            [ li [ class "form-group form-row align-items-center" ]
                [ div [ class "col-md-auto" ]
                    [ select [ class "form-control form-control-sm" ]
                        [ option [] [ text "Current scene is..." ]
                        , option [ selected True ] [ text "Current location is..." ]
                        , option [] [ text "Item is in inventory..." ]
                        , option [] [ text "Character is in location..." ]
                        ]
                    ]
                , div [ class "col-md-auto" ]
                    [ select [ class "form-control form-control-sm" ]
                        [ option [] [ text "House" ]
                        , option [ selected True ] [ text "Garden" ]
                        , option [] [ text "Marsh" ]
                        ]
                    ]
                , div [ class "col-md-auto" ]
                    [ deleteButton ]
                ]
            , li [ class "form-group form-row align-items-center" ]
                [ div [ class "col-md-auto" ]
                    [ select [ class "form-control form-control-sm" ]
                        [ option [] [ text "Current scene is..." ]
                        , option [] [ text "Current location is..." ]
                        , option [] [ text "Item is in inventory..." ]
                        , option [ selected True ] [ text "Character is in location..." ]
                        ]
                    ]
                , div [ class "col-md-auto" ]
                    [ select [ class "form-control form-control-sm" ]
                        [ option [ selected True ] [ text "Harry" ]
                        ]
                    ]
                , div [ class "col-md-auto" ]
                    [ select [ class "form-control form-control-sm" ]
                        [ option [] [ text "House" ]
                        , option [] [ text "Garden" ]
                        , option [ selected True ] [ text "Marsh" ]
                        ]
                    ]
                , div [ class "col-md-auto" ]
                    [ deleteButton ]
                ]
            , button "primary" (Just "plus") Nothing
            ]
        , label [] [ text "Changes" ]
        , ul []
            [ li [ class "form-group form-row align-items-center" ]
                [ div [ class "col-md-auto" ]
                    [ select [ class "form-control form-control-sm" ]
                        [ option [ selected True ] [ text "Move item to inventory" ]
                        , option [] [ text "Move item to location" ]
                        , option [] [ text "Move item off-screen" ]
                        ]
                    ]
                , div [ class "col-md-auto" ]
                    [ deleteButton ]
                ]
            , button "primary" (Just "plus") Nothing
            ]
        , label [] [ text "Narrative" ]
        , p [] [ small [ class "form-text text-muted" ] [ text "Add narrative blocks to cycle through each time this rule triggers, stopping on the last one.  (Note that this feature is part of the client, not part of the engine core.)" ] ]
        , ul []
            [ narrative "Some nice little story goes here"
            , narrative ""
            , button "primary" (Just "plus") Nothing
            ]
        ]


narrative : String -> Html msg
narrative text =
    li [ class "form-group form-row" ]
        [ div [ class "col" ]
            [ textarea [ class "form-control", placeholder "Narrative to display when this rule triggers...", value text ] []
            ]
        , div [ class "col-md-auto" ]
            [ deleteButton
            ]
        ]
