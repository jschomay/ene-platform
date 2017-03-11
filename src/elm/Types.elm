module Types exposing (..)

import Dict exposing (..)
import Material


type TabName
    = ItemsTab
    | LocationsTab
    | CharactersTab



-- maybe this is a dictionary?
-- and maybe its not typed anymore?
-- and finally, maybe this is loaded dynamically from a json?
-- Dict String (componentData, entitiesItBelongsTo)
-- entitiesItBelongsTo: Entity Bool


type Component
    = Display { name : String, description : String }
    | Style { selector : String }


type Msg
    = NoOp
    | ChangeActiveTab Int
    | ChangeFocusedEntity String
    | UnfocusEntity
    | SaveEntity
    | NewEntity
    | UpdateEditor String (String -> Component) String
    | AddComponent String
    | ToggleComponentDropdown
    | Mdl (Material.Msg Msg)


type alias Components =
    Dict String Component


type Entity
    = Entity Components


type EntityClasses
    = Item
    | Location
    | Character
