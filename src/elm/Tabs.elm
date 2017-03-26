module Tabs
    exposing
        ( tabToIndex
        , indexToTab
        , tabToEntityClass
        )

import Types exposing (..)


type alias TabMapping =
    List ( Int, TabName )


tabMapping : TabMapping
tabMapping =
    [ ( 0, ItemsTab )
    , ( 1, LocationsTab )
    , ( 2, CharactersTab )
    ]


tabToIndex : TabName -> Int
tabToIndex tabName =
    List.filterMap
        (\( idx, tName ) ->
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
        (\( i, tabName ) ->
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
