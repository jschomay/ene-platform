module Types exposing (..)

import Dict exposing (..)

type TabName
    = ItemsTab
    | LocationsTab
    | CharactersTab


type Component
    = Display { name : String, description : String }
    | Style { selector : String }

type Location = Location String (Dict String Component)
type Character = Character String (Dict String Component)


type alias Attributes =
    { name : String
    , description : String
    }


type Msg
    = NoOp
    | ChangeActiveTab TabName
    | ChangeFocusedItem Int
    | UpdateName String
    | UpdateDescription String
    | Save
    | Create


type alias AttributeEditor =
    { itemId : Int
    , displayName : String
    , description : String
    }
