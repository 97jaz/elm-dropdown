module Dropdown.Single exposing (..)

import Dropdown.Types as T
import Dropdown.Zipper as Zipper
import Dropdown.Common.View as Common
import Dropdown.Common.Update as Common
import Dropdown.Single.View exposing (viewMethods)
import Dropdown.Single.Update exposing (updateMethods)
import Html exposing (Html, text)


type alias Config group option =
    T.Config group option option


type alias Msg group option =
    T.Msg group option option


type alias Model group option =
    T.Model group option


view : Config group option -> Model group option -> option -> Html (Msg group option)
view config model selectedOption =
    Common.view viewMethods config model selectedOption


update :
    Config group option
    -> Msg group option
    -> Model group option
    -> option
    -> ( Model group option, option )
update config msg model option =
    case Common.update updateMethods config msg model of
        ( newModel, Nothing ) ->
            ( newModel, option )

        ( newModel, Just newOption ) ->
            ( newModel, newOption )


simpleConfig : (option -> String) -> Config Never option
simpleConfig optionString =
    { optionHtml = text << optionString
    , optionString = optionString
    , groupHtml = (always <| text "")
    , groupString = (always "")
    , selectionHtml = text << optionString
    , selectionString = optionString
    , isSelected = (==)
    }


flatModel : List option -> Model Never option
flatModel options =
    { rootItemPosition = Zipper.positionFromList options
    , focusState = T.Blurred
    }
