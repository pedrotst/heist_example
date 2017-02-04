{-# LANGUAGE  OverloadedStrings #-}

import Heist
import Heist.Interpreted
import Data.Binary.Builder
import Control.Lens
import Text.XmlHtml
import Control.Monad.IO.Class
import Data.Map.Syntax
import Data.Monoid
import qualified Data.ByteString.Lazy as BL

config :: HeistConfig IO
config =  set hcTemplateLocations [loadTemplates "templates/"] 
        . set hcSpliceConfig
            (set scLoadTimeSplices defaultInterpretedSplices mempty) 
        . set hcNamespace "" $ emptyHeistConfig

initialState = initHeist config

f = initialState >>= \e -> either (return . error . show) 
    (\s -> do
        maybeBuilder <- renderTemplate s "default"
        case maybeBuilder of
            Just (b, _ ) -> BL.putStrLn . toLazyByteString $ b
            _ -> error "deu merda"
    ) e

alexandreSplice :: RuntimeSplice IO [Node]
alexandreSplice = return [TextNode "Alexandre Lucchesi!"] 

splicesFromAlexandre :: Splices (RuntimeSplice IO Node -> Splice IO)
splicesFromAlexandre = mapS (pureSplice . textSplice) $ do

g :: IO ()
g = do
    s <- either (error . show) id <$> initialState
    maybeBuilder <- renderTemplate s "default"
    case maybeBuilder of
        Just (b, _ ) -> BL.putStrLn . toLazyByteString $ b
        _ -> error "deu merda 1"
    s' <- evalHeistT (do
            modifyHS (bindSplices ("alexandre" ## alexandreSplice'))--splices')
            s' <- getHS
            return s') 
          (TextNode "kkk") s

    maybeBuilder  <- renderTemplate s' "default"
    case maybeBuilder of
        Just (b, _ ) -> BL.putStrLn . toLazyByteString $ b
        _ -> error "deu merda"


main :: IO ()
main = do
    undefined

