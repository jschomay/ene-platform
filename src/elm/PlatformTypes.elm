module PlatformTypes exposing (..)

import Dict exposing (..)
import Material


type TabName
    = ItemsTab
    | LocationsTab
    | CharactersTab
    | RulesTab



-- maybe this is a dictionary?
-- and maybe its not typed anymore?
-- and finally, maybe this is loaded dynamically from a json?
-- Dict String (componentData, entitiesItBelongsTo)
-- entitiesItBelongsTo: Entity Bool


type Component
    = Display { name : String, description : String }
    | Style { selector : String }
    | RuleBuilder { interactionMatcher : InteractionMatcher, conditions : List Condition }


type Msg
    = NoOp
    | ChangeActiveTab Int
    | ChangeFocusedEntity String
    | UnfocusEntity
    | NewEntity
    | UpdateEntity String String (String -> Component) String
    | AddComponent String String
    | AddRule String
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
    | Rule


type InteractionMatcher
    = WithAnything
    | WithAnyItem
    | WithAnyLocation
    | WithAnyCharacter
    | With String


type Condition
    = ItemIsInInventory String
    | CharacterIsInLocation String String
    | CharacterIsNotInLocation String String



-- | CurrentLocationIs String
-- | CurrentLocationIsNot String
-- | ItemIsInLocation String String
-- | ItemIsNotInInventory String
-- | ItemIsNotInLocation String String
-- | HasPreviouslyInteractedWith String
-- | HasNotPreviouslyInteractedWith String
-- | CurrentSceneIs String


type ChangeWorldCommand
    = MoveTo String
    | AddLocation String
    | RemoveLocation String
    | MoveItemToLocationFixed String String
    | MoveItemToLocation String String
    | MoveItemToInventory String
    | MoveItemOffScreen String
    | MoveCharacterToLocation String String
    | MoveCharacterOffScreen String
    | LoadScene String
    | EndStory String
