module Manifest
    exposing
        ( Manifest
        , attributes
        , init
        , save
        , get
        )

import Types exposing (..)
import Dict


type alias Manifest =
    { currentItemId : Maybe Int
    , allItems : Dict.Dict Int Attributes
    }


init : Maybe Int -> List ( Int, Attributes ) -> Manifest
init focusedItemId attributes =
    { currentItemId = focusedItemId
    , allItems = Dict.fromList attributes
    }


attributes : Manifest -> List ( Int, Attributes )
attributes manifest =
    Dict.toList manifest.allItems


get : Int -> Manifest -> Maybe Attributes
get itemId manifest =
    Dict.get itemId manifest.allItems


save : Maybe AttributeEditor -> Manifest -> Result String Manifest
save editor manifest =
    let
        validate editor =
            let
                validateExistence editor =
                    Result.fromMaybe "no editor selected" editor

                validateDisplayNameExistence editor =
                    if not <| String.isEmpty editor.displayName then
                        Ok editor
                    else
                        Err "Display Name is required"

                validateDisplayNameUnique editor =
                    let
                        f key val =
                            key /= editor.itemId && String.toLower val.name == String.toLower editor.displayName
                    in
                        if
                            manifest.allItems
                                |> Dict.filter f
                                |> Dict.isEmpty
                        then
                            Ok editor
                        else
                            Err "Display Name should be unique"
            in
                validateExistence editor
                    |> Result.andThen validateDisplayNameExistence
                    |> Result.andThen validateDisplayNameUnique

        updateManifest editor =
            { manifest
                | allItems =
                    Dict.insert editor.itemId (Attributes editor.displayName editor.description editor.cssSelector) manifest.allItems
            }
    in
        validate editor
            |> Result.map updateManifest
