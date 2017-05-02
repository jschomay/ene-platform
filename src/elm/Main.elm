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
        currentEntities : Dict String Entity
        currentEntities =
            getActiveEntities model

        changeFocusedEntity : String -> Model -> Model
        changeFocusedEntity focusedEntityId model =
            { model
                | focusedEntity =
                    Just
                        { entityId = focusedEntityId
                        , entityClass = Tabs.tabToEntityClass model.activeTab
                        , showingComponents = False
                        }
            }

        getFocusedEntityComponents : String -> Components
        getFocusedEntityComponents focusedEntityId =
            Entity.getComponents (getFocusedEntity focusedEntityId)

        getFocusedEntity : String -> Entity
        getFocusedEntity id =
            Dict.get id currentEntities
                |> Maybe.withDefault (Entity.empty <| Tabs.tabToEntityClass model.activeTab)

        updateActiveEntityCollection : String -> Entity -> Model -> Model
        updateActiveEntityCollection entityId newEntity model =
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

            ChangeFocusedEntity focusedEntityId ->
                ( changeFocusedEntity focusedEntityId model, Cmd.none )

            UnfocusEntity ->
                ( { model | focusedEntity = Nothing }, Cmd.none )

            NewEntity ->
                let
                    newId =
                        model.lastId + 1

                    newEntityId =
                        Entity.newEntityId model.activeTab newId

                    newModel =
                        updateActiveEntityCollection newEntityId (Entity.empty <| Tabs.tabToEntityClass model.activeTab) model
                in
                    ( changeFocusedEntity newEntityId newModel
                        |> (\model ->
                                { model
                                    | lastId = newId
                                }
                           )
                    , Cmd.none
                    )

            UpdateEntity entityId componentName f v ->
                let
                    updatedComponent =
                        f v

                    updatedEntity =
                        Dict.get entityId currentEntities
                            |> Maybe.map (\(Entity components) -> Entity <| Dict.insert componentName updatedComponent components)

                    updatedModel =
                        case updatedEntity of
                            Nothing ->
                                model

                            Just newEntity ->
                                updateActiveEntityCollection entityId newEntity model
                in
                    ( updatedModel, Cmd.none )

            AddComponent entityId componentName ->
                let
                    component =
                        -- TODO find a way to get the class from the entityId instead of the focusedEntity
                        model.focusedEntity
                            |> Maybe.map .entityClass
                            |> Maybe.andThen (Component.getComponent componentName)

                    updatedEntity =
                        case component of
                            Nothing ->
                                Nothing

                            Just component ->
                                Dict.get entityId currentEntities
                                    |> Maybe.map (\(Entity components) -> Entity <| Dict.insert componentName component components)

                    closeDropdown focusedEntity =
                        { focusedEntity | showingComponents = False }

                    updateEntity model =
                        case updatedEntity of
                            Nothing ->
                                model

                            Just newEntity ->
                                updateActiveEntityCollection entityId newEntity model
                in
                    if componentName == "" then
                        ( model, Cmd.none )
                    else
                        ( { model
                            | focusedEntity = Maybe.map closeDropdown model.focusedEntity
                          }
                            |> updateEntity
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
