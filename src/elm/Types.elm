module Types exposing (..)

import Dict exposing (Dict)


type Msg
    = NoOp
    | ChangeTab Tab
    | ExpandInteractable Interactable
    | CollapseInteractable


type Interactable
    = I Item
    | C Character
    | L Location


type alias Model =
    { story : Story
    , activeTab : Tab
    , items : Dict String Item
    , locations : Dict String Location
    , characters : Dict String Character
    , rules : Dict String Rule
    }


type alias Story =
    { title : String }


type Tab
    = Items (Maybe Item)
    | Locations (Maybe Location)
    | Characters (Maybe Character)


type alias Rule =
    { trigger : String
    , conditions : List Condition
    , changes : List Changes
    }


type Item
    = Item String


type Location
    = Location String


type Character
    = Character String


type Scene
    = Scene String


type Condition
    = ItemIsInInventory Item
    | CharacterIsInLocation Character Location
    | CharacterIsNotInLocation Character Location
    | CurrentLocationIs Location
    | CurrentLocationIsNot Location
    | ItemIsInLocation Item Location
    | ItemIsNotInInventory Item
    | ItemIsNotInLocation Item Location
    | CurrentSceneIs Scene


type Changes
    = MoveTo Location
    | AddLocation Location
    | RemoveLocation Location
    | MoveItemToLocationFixed Item Location
    | MoveItemToLocation Item Location
    | MoveItemToInventory Item
    | MoveItemOffScreen Item
    | MoveCharacterToLocation Character Location
    | MoveCharacterOffScreen Character
    | LoadScene Scene
    | EndStory String


type alias Narrative =
    { ruleId : String
    , content : List String
    }
