module Component exposing (..)

import PlatformTypes exposing (..)
import Html exposing (Html)
import Components.Display
import Components.Style
import Components.RuleBuilder
import Dict
import Material
import Json.Encode as Encode


componentEntities :
    List
        { component : String
        , entities : List ( EntityClasses, Bool )
        }
componentEntities =
    [ { component = "display"
      , entities =
            [ ( Item, True )
            , ( Location, True )
            , ( Character, True )
            ]
      }
    , { component = "style"
      , entities =
            [ ( Item, False )
            , ( Location, False )
            , ( Character, False )
            ]
      }
    , { component = "rule"
      , entities =
            [ ( Rule, True ) ]
      }
    ]


view : Material.Model -> String -> String -> Component -> Html Msg
view mdl entityId componentName component =
    case component of
        Display attributes ->
            Components.Display.view mdl entityId componentName component

        Style attributes ->
            Components.Style.view mdl entityId componentName component

        RuleBuilder attributes ->
            Components.RuleBuilder.view mdl entityId componentName component


encode : Component -> Encode.Value
encode component =
    case component of
        Display params ->
            Encode.object [ ( "name", Encode.string params.name ), ( "description", Encode.string params.description ) ]

        Style params ->
            Encode.object [ ( "selector", Encode.string params.selector ) ]

        RuleBuilder params ->
            Encode.object [ ( "todo", Encode.string "" ) ]



-- TODO: figure out where the list of components should live


getDefaultComponentsFor : EntityClasses -> Components
getDefaultComponentsFor entity =
    let
        isDefaultComponent componentName =
            List.any
                (\{ component, entities } ->
                    component
                        == componentName
                        && List.member
                            ( entity, True )
                            entities
                )
                componentEntities
    in
        (allAvailableComponents entity)
            |> Dict.filter
                (\k v -> isDefaultComponent k)



-- pull out entities into some custom dictionary
-- that i can call later.


allAvailableComponents : EntityClasses -> Components
allAvailableComponents entity =
    let
        getComponent component =
            .component component

        isComponent componentToMatch =
            let
                compToMatch =
                    getComponent componentToMatch
            in
                List.any
                    (\{ component, entities } -> component == compToMatch && (List.member ( entity, True ) entities || List.member ( entity, False ) entities))
                    componentEntities

        toInit { component } =
            let
                toComponent =
                    case component of
                        "style" ->
                            Style { selector = "" }

                        "rule" ->
                            RuleBuilder { interactionMatcher = With "", conditions = [] }

                        _ ->
                            Display { name = "", description = "" }
            in
                ( component, toComponent )
    in
        componentEntities
            |> List.filter isComponent
            |> List.map toInit
            |> Dict.fromList


getAvailableComponents : EntityClasses -> Components -> Components
getAvailableComponents entity components =
    Dict.diff (allAvailableComponents entity) components


getComponent : String -> EntityClasses -> Maybe Component
getComponent name entity =
    (allAvailableComponents entity)
        |> Dict.get name


getTitle : Components -> Maybe String
getTitle components =
    Components.Display.getTitle <| Dict.get "display" components
