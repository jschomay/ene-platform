module Manifest
    exposing
        ( Manifest
        , attributes
        , init
        , focusedItem
        , changeFocusedItem
        , updateManifest
        )

import List.Zipper as Zipper
import Types exposing (..)


type Manifest
    = Manifest (Maybe (Zipper.Zipper Attributes))


init : List Attributes -> Manifest
init attributes =
    Zipper.fromList attributes |> Manifest


attributes : Manifest -> List Attributes
attributes (Manifest manifest) =
    case manifest of
        Nothing ->
            []

        Just manifest ->
            Zipper.toList manifest


focusedItem : Manifest -> Attributes
focusedItem (Manifest manifest) =
    case manifest of
        Nothing ->
            Attributes "" "" ""

        Just manifest ->
            Zipper.current manifest


changeFocusedItem : String -> Manifest -> Manifest
changeFocusedItem itemId (Manifest manifest) =
    let
        updateHelper =
            Zipper.find (\item -> item.id == itemId) << Zipper.first
    in
        Manifest <| Maybe.andThen updateHelper manifest


updateManifest : (Attributes -> Attributes) -> Manifest -> Manifest
updateManifest f (Manifest manifest) =
    Manifest <| Maybe.map (Zipper.mapCurrent f) manifest
