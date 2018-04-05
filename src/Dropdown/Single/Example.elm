module Dropdown.Single.Example exposing (main)

import Dropdown.Single as Single
import Html exposing (..)


type alias Model =
    { menuModel : Single.Model Never (Maybe State)
    , selectedItem : Maybe State
    }


type alias State =
    { abbrev : String
    , name : String
    }


type Msg
    = MenuMsg (Single.Msg Never (Maybe State))


states : List State
states =
    [ { abbrev = "MA", name = "Massachusetts" }
    , { abbrev = "NY", name = "New York" }
    , { abbrev = "WY", name = "Wyoming" }
    ]


items : List (Maybe State)
items =
    Nothing :: (List.map Just states)


config : Single.Config Never (Maybe State)
config =
    Single.simpleConfig ((Maybe.withDefault "Select a State") << (Maybe.map .name))


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model =
            { menuModel = Single.flatModel items
            , selectedItem = Nothing
            }
        , view = view
        , update = update
        }


view : Model -> Html Msg
view model =
    body
        []
        [ Single.view config model.menuModel model.selectedItem
            |> Html.map MenuMsg
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        MenuMsg subMsg ->
            case Single.update config subMsg model.menuModel model.selectedItem of
                ( menuModel, item ) ->
                    { model
                        | selectedItem = item
                        , menuModel = menuModel
                    }
