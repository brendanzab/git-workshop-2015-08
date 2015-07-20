module SlideShow
  ( Model, init
  , Action, goto, gotoNext, gotoPrevious, gotoFirst, gotoLast
  , update, view
  ) where

import Array exposing (Array)
import Html exposing (Html)
import String

import Slide


-- Model


type alias Model =
  { currentIndex : Int
  , slides : Array Html
  }


init : Array Html -> Int -> Model
init slides index =
  { currentIndex = index
  , slides = slides
  }


getCurrent : Model -> Maybe Html
getCurrent slideShow =
  Array.get slideShow.currentIndex slideShow.slides

lastIndex : Model -> Int
lastIndex slideShow =
  (Array.length slideShow.slides) - 1


-- Update


type Action
  = Goto Int
  | GotoNext
  | GotoPrevious
  | GotoFirst
  | GotoLast


goto : Int -> Action
goto = Goto


gotoNext : Action
gotoNext = GotoNext


gotoPrevious : Action
gotoPrevious = GotoPrevious


gotoFirst : Action
gotoFirst = GotoFirst


gotoLast : Action
gotoLast = GotoLast


update : Action -> Model -> Model
update action slideShow =
  let goto' = clamp 0 (lastIndex slideShow)
      nextIndex =
        case action of
          Goto index -> goto' index
          GotoNext -> goto' (slideShow.currentIndex + 1)
          GotoPrevious -> goto' (slideShow.currentIndex - 1)
          GotoFirst -> 0
          GotoLast -> lastIndex slideShow
  in
    { slideShow | currentIndex <- nextIndex }


-- View


view : Model -> Html
view slideShow =
  case getCurrent slideShow of
    Just slide -> slide
    Nothing -> Html.text <|
      "Slide #" ++ (toString slideShow.currentIndex) ++ " does not exist!"
