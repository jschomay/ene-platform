module Types exposing (..)

import Dict exposing (..)


type TabName
    = ItemsTab
    | LocationsTab
    | CharactersTab


type Component
    = Display { name : String, description : String }
    | Style { selector : String }


type Character
    = Character String (Dict String Component)


type Msg
    = NoOp
    | ChangeActiveTab TabName
    | ChangeFocusedEntity String
    | UpdateComponentProperties String Component
    | SaveEntity
    | NewEntity
    | UpdateEditor String Component (String -> Component -> Component) String



-- TODO add this Msg
-- | AddComponent String Component
