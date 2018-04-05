module Dropdown.Zipper exposing (..)

import Dropdown.Types exposing (..)
import Maybe.Extra as Maybe


currentItem : ItemPosition group option -> Item group option
currentItem (ItemPosition item _) =
    item


positionFromList : List option -> Maybe (ItemPosition Never option)
positionFromList options =
    case options of
        [] ->
            Nothing

        x :: xs ->
            Just (ItemPosition (Option x) (Top [] (List.map Option xs)))



-- NODE-BY-NODE TRAVERSAL


left : ItemPosition group option -> Maybe (ItemPosition group option)
left (ItemPosition item path) =
    case path of
        Top (l :: left) right ->
            Just (ItemPosition l (Top left (item :: right)))

        Node group (l :: left) up right ->
            Just (ItemPosition l (Node group left up (item :: right)))

        _ ->
            Nothing


right : ItemPosition group option -> Maybe (ItemPosition group option)
right (ItemPosition item path) =
    case path of
        Top left (r :: right) ->
            Just (ItemPosition r (Top (item :: left) right))

        Node group left up (r :: right) ->
            Just (ItemPosition r (Node group (item :: left) up right))

        _ ->
            Nothing


up : ItemPosition group option -> Maybe (ItemPosition group option)
up (ItemPosition item path) =
    case path of
        Node group left up right ->
            Just (ItemPosition (Group group (List.append (List.reverse left) (item :: right))) up)

        Top _ _ ->
            Nothing


down : ItemPosition group option -> Maybe (ItemPosition group option)
down (ItemPosition item path) =
    case item of
        Group group (x :: xs) ->
            Just (ItemPosition x (Node group [] path xs))

        _ ->
            Nothing



-- PREORDER TRAVERSAL


next : ItemPosition group option -> Maybe (ItemPosition group option)
next pos =
    down pos
        |> Maybe.orElseLazy (\_ -> right pos)
        |> Maybe.orElseLazy (\_ -> nextUp pos)


prev : ItemPosition group option -> Maybe (ItemPosition group option)
prev pos =
    left pos
        |> Maybe.andThen (Just << bottomRight)
        |> Maybe.orElseLazy (\_ -> up pos)


nextUp : ItemPosition group option -> Maybe (ItemPosition group option)
nextUp pos =
    up pos
        |> Maybe.andThen (\parentPos -> right pos |> Maybe.orElseLazy (\_ -> nextUp parentPos))


bottomRight : ItemPosition group option -> ItemPosition group option
bottomRight pos =
    down pos
        |> Maybe.andThen (Just << bottomRight << rightmostSibling)
        |> Maybe.withDefault pos


rightmostSibling : ItemPosition group option -> ItemPosition group option
rightmostSibling pos =
    right pos
        |> Maybe.andThen (Just << rightmostSibling)
        |> Maybe.withDefault pos



-- MAP


mapRight : (ItemPosition group option -> a) -> Maybe (ItemPosition group option) -> List a
mapRight fn maybePos =
    let
        go maybePos results =
            case maybePos of
                Nothing ->
                    List.reverse results

                Just pos ->
                    go (right pos) ((fn pos) :: results)
    in
        go maybePos []


mapChildren : (ItemPosition group option -> a) -> ItemPosition group option -> List a
mapChildren fn pos =
    mapRight fn (down pos)
