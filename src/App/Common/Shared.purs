module App.Shared where

import Prelude
import Data.Maybe (Maybe(..))
import Data.String (split, Pattern(..))
import Halogen.HTML (ClassName(..), IProp)
import Halogen.HTML.Properties (classes, style)
import Web.HTML (HTMLElement)

type Props
  = ( target :: HTMLElement
    , parent :: HTMLElement
    , eventName :: String
    )

css :: forall r i. String -> IProp ( class :: String | r ) i
css s = classes $ (\i -> ClassName i) <$> split (Pattern " ") s

toggleClass :: forall r i. String -> String -> Boolean -> IProp ( class :: String | r ) i
toggleClass c cs b
  | b == true = css $ cs <> " " <> c
  | otherwise = css cs

toggleVisibility :: forall r i. Boolean -> IProp ( style ∷ String | r ) i
toggleVisibility b
  | b == true = style "display: block"
  | otherwise = style "display: none"

ifTrue :: forall a b. Maybe a -> (a -> b) -> Maybe b
ifTrue x fn = case x of
  Just x' -> Just $ fn x'
  Nothing -> Nothing
