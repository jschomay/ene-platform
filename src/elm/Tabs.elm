module Tabs
    exposing
        ( tabToIndex
        , indexToTab
        , tabToEntityClass
        , render
        )

import PlatformTypes exposing (..)
import Material.Tabs as Tabs
import Material.Options as Options
import Material.Icon as Icon
import Material
import Dict exposing (Dict)
import Html exposing (Html, text)


type TabProperty
    = TabId Int
    | Tab TabName
    | TabName String


type TabProperties
    = List TabProperty


type alias TabMapping =
    List ( Int, TabName, String )


tabMapping : TabMapping
tabMapping =
    [ ( 0, ItemsTab, "card_travel" )
    , ( 1, LocationsTab, "my_location" )
    , ( 2, CharactersTab, "person" )
    , ( 3, RulesTab, "person" )
    ]


render :
    Material.Model
    -> Int
    -> Dict String Entity
    -> List (Tabs.Label msg)
render mdl activeTab items =
    let
        toTab ( i, tabName, icon ) =
            Tabs.label
                [ Options.center ]
                [ Icon.i icon
                , Options.span [ Options.css "width" "4px" ] []
                , text <| tabToName tabName
                ]
    in
        List.map toTab tabMapping


tabToName : TabName -> String
tabToName tabName =
    toString tabName
        |> String.dropRight 3


tabToIndex : TabName -> Int
tabToIndex tabName =
    List.filterMap
        (\( idx, tName, _ ) ->
            if tName == tabName then
                Just idx
            else
                Nothing
        )
        tabMapping
        |> List.head
        |> Maybe.withDefault 0


indexToTab : Int -> TabName
indexToTab idx =
    List.filterMap
        (\( i, tabName, _ ) ->
            if i == idx then
                Just tabName
            else
                Nothing
        )
        tabMapping
        |> List.head
        |> Maybe.withDefault ItemsTab


tabToEntityClass : TabName -> EntityClasses
tabToEntityClass tabName =
    case tabName of
        ItemsTab ->
            Item

        LocationsTab ->
            Location

        CharactersTab ->
            Character

        RulesTab ->
            Rule
