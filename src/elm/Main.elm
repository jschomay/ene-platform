module Main exposing (..)

import Html exposing (..)
import PlatformTypes exposing (..)
import Views.Layout
import Dict exposing (Dict)
import Entity exposing (..)
import Tabs
import Encode
import Component
import Material


-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Model =
    { items : Dict String Entity
    , locations : Dict String Entity
    , characters : Dict String Entity
    , rules : Dict String Entity
    , activeTab : TabName
    , lastId : Int
    , focusedEntity :
        Maybe
            { entityId : String
            , entityClass : EntityClasses
            , editor : Components
            , showingComponents : Bool
            }
    , mdl : Material.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        items =
            (Dict.singleton "items1" <|
                Entity.init Location
                    (Dict.singleton "display"
                        (Display
                            { name = "item1"
                            , description = "my item"
                            }
                        )
                    )
            )

        locations =
            (Dict.fromList
                [ ( "locations1"
                  , Entity.init Location
                        (Dict.fromList
                            [ ( "display"
                              , Display
                                    { name = "location1"
                                    , description = "my location"
                                    }
                              )
                            , ( "style"
                              , Style
                                    { selector = "mySelector"
                                    }
                              )
                            ]
                        )
                  )
                , ( "locations2"
                  , Entity.empty Location
                  )
                ]
            )

        characters =
            (Dict.singleton "characters1" (Entity.empty Character))

        rules =
            Dict.singleton "rule1" <| Entity.empty Rule
    in
        ( { items = items
          , locations = locations
          , characters = characters
          , rules = rules
          , activeTab = ItemsTab
          , lastId = 3
          , focusedEntity = Nothing
          , mdl = Material.model
          }
        , Cmd.none
        )



-- UPDATE


getActiveEntities : Model -> Dict String Entity
getActiveEntities model =
    case model.activeTab of
        ItemsTab ->
            model.items

        LocationsTab ->
            model.locations

        CharactersTab ->
            model.characters

        RulesTab ->
            model.rules


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        currentEntities =
            getActiveEntities model

        changeFocusedEntity focusedEntity model =
            { model
                | focusedEntity =
                    Just
                        { entityId = focusedEntity
                        , editor =
                            (Entity.getComponents
                                (Dict.get focusedEntity currentEntities
                                    |> Maybe.withDefault (Entity.empty <| Tabs.tabToEntityClass model.activeTab)
                                )
                            )
                        , entityClass = Tabs.tabToEntityClass model.activeTab
                        , showingComponents = False
                        }
            }

        updateActiveEntityCollection entityId newEntity =
            case model.activeTab of
                ItemsTab ->
                    { model | items = Dict.insert entityId newEntity model.items }

                LocationsTab ->
                    { model | locations = Dict.insert entityId newEntity model.locations }

                CharactersTab ->
                    { model | characters = Dict.insert entityId newEntity model.characters }

                RulesTab ->
                    { model | rules = Dict.insert entityId newEntity model.rules }
    in
        case msg of
            NoOp ->
                ( model, Cmd.none )

            ChangeActiveTab newTabIndex ->
                let
                    newActiveTab =
                        Tabs.indexToTab newTabIndex
                in
                    ( { model
                        | activeTab = newActiveTab
                        , focusedEntity = Nothing
                      }
                    , Cmd.none
                    )

            ChangeFocusedEntity focusedEntity ->
                ( changeFocusedEntity focusedEntity model, Cmd.none )

            UnfocusEntity ->
                ( { model | focusedEntity = Nothing }, Cmd.none )

            NewEntity ->
                let
                    newId =
                        model.lastId + 1

                    newEntityId =
                        Entity.newEntityId model.activeTab newId

                    newModel =
                        updateActiveEntityCollection newEntityId (Entity.empty <| Tabs.tabToEntityClass model.activeTab)
                in
                    ( changeFocusedEntity newEntityId newModel
                        |> (\model ->
                                { model
                                    | lastId = newId
                                }
                           )
                    , Cmd.none
                    )

            UpdateRuleConditions ruleId newConditions ->
                -- TODO find ruleid and update the conditions with newCondition
                ( model, Cmd.none )

            UpdateEditor componentName f newVal ->
                let
                    updateModel focusedEntity =
                        { focusedEntity | editor = Dict.insert componentName (f newVal) focusedEntity.editor }
                            |> \{ entityId, entityClass, editor, showingComponents } ->
                                updateActiveEntityCollection entityId (Entity.update (Entity.empty <| Tabs.tabToEntityClass model.activeTab) editor)
                                    |> \model -> { model | focusedEntity = Just { entityId = entityId, entityClass = entityClass, editor = editor, showingComponents = showingComponents } }

                    updatedModel =
                        Maybe.map updateModel model.focusedEntity
                            |> Maybe.withDefault model
                in
                    -- TODO: refactor this bad boy, but for now just keeping forward
                    ( updatedModel, Cmd.none )

            AddComponent name ->
                let
                    component =
                        model.focusedEntity
                            |> Maybe.map .entityClass
                            |> Maybe.andThen (Component.getComponent name)

                    withDefault component =
                        case component of
                            RuleBuilder component ->
                                let
                                    entityId =
                                        Maybe.map .entityId model.focusedEntity |> Maybe.withDefault ""
                                in
                                    RuleBuilder { component | interactionMatcher = With entityId }

                            _ ->
                                component

                    updateHelper focusedEntity =
                        case component of
                            Nothing ->
                                -- TODO: figure out a better way to handle all this
                                Debug.crash "Could not find the component..."

                            Just component ->
                                { focusedEntity
                                    | editor = Dict.insert name (component |> withDefault) focusedEntity.editor
                                    , showingComponents = False
                                }
                in
                    if name == "" then
                        ( model, Cmd.none )
                    else
                        ( { model
                            | focusedEntity = Maybe.map updateHelper model.focusedEntity
                          }
                        , Cmd.none
                        )

            ToggleComponentDropdown ->
                let
                    updateFocusedEntity =
                        Maybe.map
                            (\focusedEntity ->
                                { focusedEntity
                                    | showingComponents = not focusedEntity.showingComponents
                                }
                            )
                            model.focusedEntity
                in
                    ( { model | focusedEntity = updateFocusedEntity }, Cmd.none )

            Mdl message ->
                Material.update Mdl message model


view : Model -> Html Msg
view model =
    let
        exportData =
            Encode.toJson
                { items = model.items
                , locations = model.locations
                , characters = model.characters
                , rules = model.rules
                }
    in
        Views.Layout.view
            { mdl = model.mdl
            , activeTab = model.activeTab
            , exportJson = exportData
            , items = (getActiveEntities model)
            , focusedEntity = model.focusedEntity
            }
