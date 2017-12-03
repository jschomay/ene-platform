module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Views.InteractablesList
import Dict exposing (Dict)
import Types exposing (..)


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


mockItems : Dict String Item
mockItems =
    Dict.fromList
        [ ( "item1", Item "umbrella" )
        , ( "item2", Item "note" )
        , ( "item3", Item "spectacles" )
        ]


init : ( Model, Cmd Msg )
init =
    ( { story = { title = "My story title" }
      , activeTab = Items Nothing
      , items = mockItems
      , locations = Dict.singleton "location1" <| Location "Home"
      , characters = Dict.singleton "character1" <| Character "Harry"
      , rules = Dict.empty
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ChangeTab tab ->
            { model | activeTab = tab } ! []

        ExpandInteractable interactable ->
            case interactable of
                I item ->
                    { model | activeTab = Items <| Just item } ! []

                L location ->
                    { model | activeTab = Locations <| Just location } ! []

                C character ->
                    { model | activeTab = Characters <| Just character } ! []

        CollapseInteractable ->
            case model.activeTab of
                Items _ ->
                    { model | activeTab = Items Nothing } ! []

                Locations _ ->
                    { model | activeTab = Locations Nothing } ! []

                Characters _ ->
                    { model | activeTab = Characters Nothing } ! []


subscribe : Model -> Sub Msg
subscribe model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ header model
        , body model
        ]


header : Model -> Html Msg
header model =
    nav [ class "navbar navbar-expand navbar-dark bg-dark" ]
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


body : Model -> Html Msg
body model =
    let
        tabClasses tab =
            classList
                [ ( "nav-link", True )
                , ( "active"
                  , case model.activeTab of
                        Items _ ->
                            tab == Items Nothing

                        Locations _ ->
                            tab == Locations Nothing

                        Characters _ ->
                            tab == Characters Nothing
                  )
                ]
    in
        div [ class "container pt-3" ]
            [ div [ class "card" ]
                [ div [ class "card-header" ]
                    [ ul [ class "nav nav-tabs nav-fill card-header-tabs" ]
                        [ li [ class "nav-item" ]
                            [ span
                                [ onClick <| ChangeTab <| Locations Nothing
                                , tabClasses <| Locations Nothing
                                ]
                                [ span
                                    [ class "oi oi-home mr-2"
                                    ]
                                    []
                                , text "Locations"
                                ]
                            ]
                        , li [ class "nav-item" ]
                            [ span
                                [ onClick <| ChangeTab <| Characters Nothing
                                , tabClasses <| Characters Nothing
                                ]
                                [ span
                                    [ class "oi oi-person mr-2"
                                    ]
                                    []
                                , text "Characters"
                                ]
                            ]
                        , li [ class "nav-item" ]
                            [ span
                                [ onClick <| ChangeTab <| Items Nothing
                                , tabClasses <| Items Nothing
                                ]
                                [ span
                                    [ class "oi oi-briefcase mr-2"
                                    ]
                                    []
                                , text "Items"
                                ]
                            ]
                        ]
                    ]
                , div [ class "card-body" ]
                    [ Views.InteractablesList.view model
                    , button [ class "btn btn-primary btn-sm" ] [ small [ class "oi oi-plus mr-2" ] [], text "add item" ]
                    ]
                ]
            ]
