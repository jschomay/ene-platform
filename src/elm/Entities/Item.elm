module Entities.Item
    exposing
        ( Item
        , init
        )

import Types exposing (..)
import Dict exposing (Dict)


type Item
    = Item (Dict String Component)


init : Item
init =
    Item Dict.empty
