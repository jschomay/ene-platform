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
    | ChangeFocusedItem String
    | UpdateName String
    | UpdateDescription String
