module Tests exposing (..)

import Test exposing (..)
import Tests.Item


all : Test
all =
    describe "All suites"
        [ Tests.Item.all ]
