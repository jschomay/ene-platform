module Types exposing (..)


type TabName
    = Items
    | Locations
    | Characters


type alias Attributes =
    { name : String
    , description : String
    , id : String
    }


type Msg
    = NoOp
    | ChangeActiveTab TabName
