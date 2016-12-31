module Manifest
    exposing
        ( Manifest
        , attributes
        , init
        , focusedItem
        , changeFocusedItem
        , update
        )

import Types exposing (..)
import Dict


type alias Manifest =
    { currentItemId : Maybe String
    , allItems : Dict.Dict String Attributes
    }


init : Maybe String -> List ( String, Attributes ) -> Manifest
init focusedItemId attributes =
    { currentItemId = focusedItemId
    , allItems = Dict.fromList attributes
    }


attributes : Manifest -> List ( String, Attributes )
attributes manifest =
    Dict.toList manifest.allItems


focusedItem : Manifest -> Maybe Attributes
focusedItem { currentItemId, allItems } =
    currentItemId
        |> Maybe.andThen (flip Dict.get allItems)


changeFocusedItem : String -> Manifest -> Manifest
changeFocusedItem itemId manifest =
    { manifest | currentItemId = Just itemId }


update : (Attributes -> Attributes) -> Manifest -> Manifest
update f manifest =
    case manifest.currentItemId of
        Nothing ->
            manifest

        Just currentItemId ->
            { manifest
                | allItems =
                    Dict.update currentItemId (Maybe.map f) manifest.allItems
            }
