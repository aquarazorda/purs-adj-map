module App.Langs where

import Prelude

import App.Reqs as REQ
import Data.Argonaut (Json, decodeJson)
import Data.Either (hush)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Foreign.Object (Object)
import Foreign.Object as Object
import Halogen.HTML as HH

type Langs = Object String

lang :: forall a b. Maybe Langs -> String -> HH.HTML a b
lang ls l = case getLangValue ls l of
    Just s -> HH.text s
    Nothing -> HH.text $ "invalid lang " <> l

getLangValue :: Maybe Langs -> String -> Maybe String
getLangValue ls l = do
  langs <- ls
  Object.lookup l langs

langReq :: Aff (Maybe Json)
langReq = REQ.getAffReq "https://newstatic.adjarabet.com/static/langkaNew.json"

getLangs :: Maybe Json -> Maybe Langs
getLangs j = j >>= hush <$> decodeJson