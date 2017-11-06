module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscribe
        }



-- MODEL


type alias Model =
    { story : Story }


type alias Story =
    { title : String }


init : ( Model, Cmd Msg )
init =
    ( { story = { title = "My story title" } }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscribe : Model -> Sub Msg
subscribe model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ nav [ class "navbar navbar-expand navbar-dark bg-dark" ]
            [ span [ class "navbar-brand" ] [ text <| "\"" ++ model.story.title ++ "\"" ]
            , div [ class "collapse navbar-collapse" ]
                [ ul [ class "navbar-nav align-items-center" ]
                    [ li [ class "nav-item active" ]
                        [ a [ class "nav-link", href "#" ]
                            [ text "Editor " ]
                        ]
                    , li [ class "nav-item" ]
                        [ a [ class "nav-link disabled", href "#" ]
                            [ text "Preview" ]
                        ]
                    , li [ class "nav-item" ]
                        [ a [ class "nav-link disabled", href "#" ]
                            [ text "Settings / Export" ]
                        ]
                    ]
                ]
            , span [ class "navbar-text" ] [ a [ href "http://elmnarrativeengine.com/", target "blank" ] [ text "Elm Narrative Engine Platform" ] ]
            ]
        , div [ class "container pt-3" ]
            [ div [ class "card" ]
                [ div [ class "card-header" ]
                    [ ul [ class "nav nav-tabs nav-fill card-header-tabs" ]
                        [ li [ class "nav-item" ]
                            [ span [ class "nav-link" ]
                                [ span [ class "oi oi-home mr-2" ] [], text "Locations" ]
                            ]
                        , li [ class "nav-item" ]
                            [ span [ class "nav-link" ]
                                [ span [ class "oi oi-person mr-2" ] [], text "Characters" ]
                            ]
                        , li [ class "nav-item" ]
                            [ span [ class "nav-link active" ]
                                [ span [ class "oi oi-briefcase mr-2" ] [], text "Items" ]
                            ]
                        ]
                    ]
                , div [ class "card-body" ]
                    [ interactableListView
                    , button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus mr-2" ] [], text "add item" ]
                    ]
                ]
            ]
        ]


interactableListView : Html Msg
interactableListView =
    div [ class "list-group mb-2" ]
        [ a [ href "#", class "list-group-item list-group-item-action d-flex align-items-center" ]
            [ small [ class "oi oi-briefcase mr-2" ] []
            , span [ class "mr-auto" ] [ text "umbrella" ]
            , button [ class "btn btn-danger btn-sm float-right" ] [ small [ class "oi oi-trash" ] [] ]
            ]
        , Html.form [ class "list-group-item list-group-item-success" ]
            [ h4 [] [ small [ class "oi oi-briefcase mr-2" ] [], text "Edit item", button [ class "btn btn-light btn-sm float-right" ] [ small [ class "oi oi-minus" ] [] ] ]
            , div [ class "form-group" ]
                [ label [] [ text "Display name" ]
                , input [ class "form-control", value "note from harry" ] []
                ]
            , label [] [ text "Rules" ]
            , div [ class "list-group mb-2" ]
                [ a [ href "#", class "list-group-item list-group-item-action" ] [ small [ class "oi oi-bolt mr-2" ] [], text "description" ]
                , ruleView
                , a [ href "#", class "list-group-item list-group-item-action" ] [ small [ class "oi oi-bolt mr-2" ] [], text "give to harry" ]
                , a [ href "#", class "list-group-item list-group-item-action" ] [ small [ class "oi oi-bolt mr-2" ] [], text "hide from harry" ]
                ]
            , button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus mr-2" ] [], text "add rule" ]
            ]
        , a [ href "#", class "list-group-item list-group-item-action d-flex align-items-center" ]
            [ small [ class "oi oi-briefcase mr-2" ] []
            , span [ class "mr-auto" ] [ text "red marble" ]
            , button [ class "btn btn-danger btn-sm float-right" ] [ small [ class "oi oi-trash" ] [] ]
            ]
        , a [ href "#", class "list-group-item list-group-item-action d-flex align-items-center" ]
            [ small [ class "oi oi-briefcase mr-2" ] []
            , span [ class "mr-auto" ] [ text "green marble" ]
            , button [ class "btn btn-danger btn-sm" ] [ small [ class "oi oi-trash" ] [] ]
            ]
        ]


ruleView : Html Msg
ruleView =
    div [ class "list-group-item list-group-item-warning" ]
        [ h4 [] [ small [ class "oi oi-bolt mr-2" ] [], text "Edit rule", button [ class "btn btn-light btn-sm float-right" ] [ small [ class "oi oi-minus" ] [] ] ]
        , div [ class "form-group" ]
            [ label [] [ text "Summary" ]
            , input [ class "form-control", value "take note when harry is gone" ] []
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
                    [ button [ class "btn btn-sm btn-danger" ] [ small [ class " oi oi-trash" ] [] ] ]
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
                    [ button [ class "btn btn-sm btn-danger" ] [ small [ class " oi oi-trash" ] [] ] ]
                ]
            , button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus" ] [] ]
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
                    [ button [ class "btn btn-sm btn-danger" ] [ small [ class " oi oi-trash" ] [] ] ]
                ]
            , button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus" ] [] ]
            ]
        , label [] [ text "Narrative" ]
        , p [] [ small [ class "form-text text-muted" ] [ text "Add narrative blocks to cycle through each time this rule triggers, stopping on the last one.  (Note that this feature is part of the client, not part of the engine core.)" ] ]
        , ul []
            [ li [ class "form-group form-row" ]
                [ div [ class "col" ]
                    [ textarea [ class "form-control", placeholder "Narrative to display when this rule triggers...", value "Just a simple note, not much of value." ] []
                    ]
                , div [ class "col-md-auto" ]
                    [ button [ class "btn btn-sm btn-danger" ] [ small [ class " oi oi-trash" ] [] ]
                    ]
                ]
            , li [ class "form-group form-row" ]
                [ div [ class "col" ]
                    [ textarea [ class "form-control", placeholder "Narrative to display when this rule triggers...", value "" ] []
                    ]
                , div [ class "col-md-auto" ]
                    [ button [ class "btn btn-sm btn-danger" ] [ small [ class " oi oi-trash" ] [] ]
                    ]
                ]
            , button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus" ] [] ]
            ]
        ]


ruleView2 : Html Msg
ruleView2 =
    div [ class "list-group-item" ]
        [ input [ class "form-control", value "description" ] []
        , small [ class "form-text text-muted" ] [ text "The summary is only to help you organize your rules and is not used by the engine." ]
        , label [] [ text "Conditions" ]
        , ul []
            [ button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus" ] [] ]
            ]
        , label [] [ text "Changes" ]
        , ul []
            [ button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus" ] [] ]
            ]
        , label [] [ text "Narrative" ]
        , div [ class "form-group" ]
            [ textarea [ class "form-control", placeholder "Narrative to display when this rule triggers...", value "A really nifty little item" ] []
            ]
        ]
