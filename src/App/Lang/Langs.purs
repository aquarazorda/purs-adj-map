module App.Langs where

import Prelude
import App.Events as Events
import App.Shared (Props)
import Control.Promise (toAffE)
import Data.Foldable (foldl)
import Data.Map (Map, empty, insert)
import Data.Traversable (sequence)
import Effect.Aff (Aff)

type Langs
  = Map String String

type LangItem
  = { lang :: Boolean
    , langId :: String
    }

getLang :: Record Props -> String -> Aff String
getLang p e = toAffE $ Events.getLang p "getLang" e

getLangs :: Record Props -> Array String -> Aff Langs
getLangs ps ls = sequence $ foldl (\acc l -> insert l (getLang ps l) acc) empty ls
