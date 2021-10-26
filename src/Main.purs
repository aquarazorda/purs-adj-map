module Main where

import Prelude
import App (Input)
import App as App
import Data.Function.Uncurried (Fn1)
import Effect (Effect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

default :: Fn1 Input (Effect Unit)
default params =
  HA.runHalogenAff do
    runUI App.component params params.props.target
