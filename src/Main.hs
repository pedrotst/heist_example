{-# LANGUAGE OverloadedStrings #-}

import Heist
import Heist.Interpreted
import Data.Binary.Builder
import Control.Lens.Setter
import Text.XmlHtml
import Control.Monad.IO.Class
import Data.Map.Syntax
import Data.Monoid
import qualified Data.ByteString.Lazy as BL

config :: HeistConfig IO
config =  set hcTemplateLocations [loadTemplates "templates/"] 
        . set hcSpliceConfig
            (set scLoadTimeSplices (defaultInterpretedSplices <> ("alexandre" ## alexandreSplice)) mempty) 
        . set hcNamespace "" $ emptyHeistConfig

f = initHeist config >>= \e -> either (return . error . show) 
    (\s -> do
        maybeBuilder <- renderTemplate s "default"
        case maybeBuilder of
            Just (b, _ ) -> BL.putStrLn . toLazyByteString $ b
            _ -> error "deu merda"
    ) e

alexandreSplice :: Splice IO
alexandreSplice = return [TextNode "Alexandre Lucchesi!"] 

alexandreSplice' :: Splice IO
alexandreSplice' = return [TextNode "Alexandre not Lucchesi!"] 
{-
-- TODO 
g :: IO ()
g = do 
    e <- initHeist config
    let s = either (error . show) id e
        s' = 
    return s
-}


main :: IO ()
main = do
    undefined

