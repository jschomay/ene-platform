module Tests.Entity exposing (..)

import Test exposing (..)
import Expect
import Entity
import Types exposing (..)
import Dict


all : Test
all =
    describe "Entity"
        [ describe "update"
            [ test "merges new data over existing" <|
                \() ->
                    let
                        components1 =
                            Dict.insert
                                "comp1"
                                (Display
                                    { name = "x"
                                    , description = "y"
                                    }
                                )
                                Dict.empty

                        components2 =
                            Dict.fromList
                                [ ( "comp1"
                                  , Display { name = "overwritten", description = "y" }
                                  )
                                , ( "comp2"
                                  , (Style { selector = "x" })
                                  )
                                ]

                        existing =
                            Entity.update Entity.empty components1

                        merged =
                            Entity.update existing components2
                    in
                        Expect.equal
                            (Dict.fromList
                                [ ( "comp1"
                                  , Display { name = "overwritten", description = "y" }
                                  )
                                , ( "comp2"
                                  , Style { selector = "x" }
                                  )
                                ]
                            )
                            (Entity.getComponents <| Entity.update merged Dict.empty)
            ]
        , describe "newEntityId"
            [ test "generates correct structure" <|
                \() ->
                    Expect.equal "items123" <| Entity.newEntityId ItemsTab 123
            ]
        ]
