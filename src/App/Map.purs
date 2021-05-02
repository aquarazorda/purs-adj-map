module App.Map where

import Prelude

import App.Branches as BR
import Control.Promise (Promise, toAffE)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)

foreign import initMap :: Array BR.BranchData -> Effect (Promise Unit)

initMap' :: Maybe (Array BR.BranchData) -> Aff Unit
initMap' bs = case bs of
    Just b  -> toAffE $ initMap b
    Nothing -> pure unit
    
