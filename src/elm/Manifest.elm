module Manifest exposing (Manifest, attributes, init)

import List.Zipper as Zipper
import Types exposing (..)


type Manifest
    = Manifest (Maybe (Zipper.Zipper Attributes))


attributes : Manifest -> List Attributes
attributes (Manifest manifest) =
    case manifest of
        Nothing ->
            []

        Just manifest ->
            Zipper.toList manifest


init : List Attributes -> Manifest
init attributes =
    Zipper.fromList attributes |> Manifest
