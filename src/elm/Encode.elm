module Encode exposing (toJson)

import Json.Encode as Encode
import Dict exposing (Dict)
import Types exposing (..)


toJson : { a | items : Dict String Entity, locations : Dict String Entity, characters : Dict String Entity } -> String
toJson { items, locations, characters } =
    Encode.object
        [ ( "items", encodeDict items )
        , ( "locations", encodeDict locations )
        , ( "characters", encodeDict characters )
        ]
        |> Encode.encode 2


encodeDict : Dict String Entity -> Encode.Value
encodeDict entities =
    Dict.toList entities
        |> List.map (\( k, v ) -> ( k, encodeEntity v ))
        |> Encode.object


encodeEntity : Entity -> Encode.Value
encodeEntity (Entity components) =
    Dict.toList components
        |> List.map (\( k, v ) -> ( k, encodeComponent v ))
        |> Encode.object


encodeComponent : Component -> Encode.Value
encodeComponent component =
    case component of
        Display params ->
            Encode.object [ ( "name", Encode.string params.name ), ( "description", Encode.string params.description ) ]

        Style params ->
            Encode.object [ ( "selector", Encode.string params.selector ) ]
