module Component exposing (..)

import Types exposing (..)
import Html exposing (Html)
import Components.Display
import Components.Style
import Dict
import Material


view : Material.Model -> String -> Component -> Html Msg
view mdl componentName component =
    case component of
        Display attributes ->
            Components.Display.view mdl componentName component

        Style attributes ->
            Components.Style.view mdl componentName component



-- TODO: figure out where the list of components should live


allAvailableComponents : Components
allAvailableComponents =
    Dict.fromList
        [ ( "display", Display { name = "", description = "" } )
        , ( "style", Style { selector = "" } )
        ]


getAvailableComponents : Components -> Components
getAvailableComponents components =
    Dict.diff allAvailableComponents components


getComponent : String -> Maybe Component
getComponent name =
    allAvailableComponents
        |> Dict.get name


getTitle : Components -> Maybe String
getTitle components =
    Components.Display.getTitle <| Dict.get "display" components
