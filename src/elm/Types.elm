module Types exposing (..)


type TabName
    = Items
    | Locations
    | Characters


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
