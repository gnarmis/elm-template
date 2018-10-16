module Routing exposing (..)

import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)
import Url exposing (Url)
import Mission exposing (MissionId(..))

type Route
    = CurriculumRoute
    | MissionRoute MissionId

parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map CurriculumRoute Parser.top
        , Parser.map MissionRoute (s "missions" </> (Parser.custom "MISSIONS" (\str -> String.toInt str |> Maybe.map MissionId)))
        ]

fromUrl : Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    -- { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    url |> Parser.parse parser
