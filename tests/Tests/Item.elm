module Tests.Item exposing (..)

import Test exposing (..)
import Expect
import Entities.Item as Item
import Types exposing (..)
import Dict


all : Test
all =
    describe "Item"
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
                            Item.update Item.empty components1

                        merged =
                            Item.update existing components2
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
                            (Item.getComponents <| Item.update merged Dict.empty)
            ]
        ]
