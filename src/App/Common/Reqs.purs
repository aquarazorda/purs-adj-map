module App.Reqs where
  
import Prelude

import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat
import Data.Argonaut (Json)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)

getAffReq :: String -> Aff (Maybe Json)
getAffReq u = do
  res <- AX.get ResponseFormat.json u
  case res of
    Left _ -> pure $ Nothing
    Right response -> pure $ Just response.body