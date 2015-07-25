module SlideShow
  ( SlideShow, Slide, init
  , Action, goto, gotoNext, gotoPrevious, gotoFirst, gotoLast
  , update, view
  ) where

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as Html
import TypedStyles as Css exposing (px)
import String


-- SlideShow


type alias Slide =
  { view: List Html
  , notes: String
  }


type alias SlideShow =
  { currentIndex : Int
  , currentSlide : Maybe Slide
  , slides : Array Slide
  }


init : Array Slide -> Int -> SlideShow
init slides index =
  update (goto index)
    { currentIndex = 0
    , currentSlide = Nothing
    , slides = slides
    }


{-| A slide to be shown if the index is out of bounds -}
overflowSlide : Int -> Slide
overflowSlide index =
  { view = [ Html.text <| "Slide #" ++ (toString index) ++ " does not exist!" ]
  , notes = ""
  }


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


update : Action -> SlideShow -> SlideShow
update action slideShow =
  let lastIndex = (Array.length slideShow.slides) - 1
      clampIndex = clamp 0 lastIndex
      nextIndex =
        case action of
          Goto index -> clampIndex index
          GotoNext -> clampIndex (slideShow.currentIndex + 1)
          GotoPrevious -> clampIndex (slideShow.currentIndex - 1)
          GotoFirst -> 0
          GotoLast -> lastIndex
  in
    { slideShow
    | currentIndex <- nextIndex
    , currentSlide <- Array.get nextIndex slideShow.slides
    }


-- View


view : { width : Int, height : Int } -> SlideShow -> Html
view { width, height } slideShow =
  Html.section
    [ Html.class "slide"
    , Html.style
        [ Css.width width px
        , Css.height height px
        ]
    ] <|
    case slideShow.currentSlide of
      Just slide -> slide.view
      Nothing -> (overflowSlide slideShow.currentIndex).view
