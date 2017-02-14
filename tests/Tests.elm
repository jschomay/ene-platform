module Tests exposing (..)

import Test exposing (..)
import Tests.Entity


all : Test
all =
    describe "All suites"
        [ Tests.Entity.all ]
