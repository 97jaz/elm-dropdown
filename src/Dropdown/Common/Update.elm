module Dropdown.Common.Update exposing (update)

import Dropdown.Types exposing (..)
import Dropdown.Zipper as Zipper


update :
    UpdateMethods
    -> Config group option selection
    -> Msg group option selection
    -> Model group option
    -> ( Model group option, Maybe option )
update methods config msg model =
    case msg of
        NoOp ->
            ( model, Nothing )

        FocusStateMsg focusState ->
            ( { model | focusState = focusState }, Nothing )

        SelectMsg option ->
            ( modelOnSelect methods model, Just option )


modelOnSelect : UpdateMethods -> Model group option -> Model group option
modelOnSelect methods model =
    if methods.closeOnSelect then
        { model | focusState = Focused }
    else
        model
