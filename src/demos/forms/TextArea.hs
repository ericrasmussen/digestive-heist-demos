{-# LANGUAGE OverloadedStrings #-}

module Demos.Forms.TextArea
       ( textAreaHandler
       , textAreaSplices
       ) where

import Heist
import Heist.Compiled (Splice)
import Snap.Snaplet.Heist
import Snap.Core (MonadSnap)
import Text.Digestive
import Data.Text (Text)
import qualified Data.Text as T
import Control.Applicative ((<$>))
import Application (AppHandler)
import Demos.Utils.Forms (makeFormSplices)


-- -----------------------------------------------------------------------------
-- * Define your data

data TextBlob = TextBlob {
  getText :: Text
  } deriving Show

-- -----------------------------------------------------------------------------
-- * Provide a way to render your data type as Text

-- this example will replace line breaks with break tags
asText :: TextBlob -> Text
asText = T.intercalate "<br />" . T.lines . getText

-- -----------------------------------------------------------------------------
-- * Optionally create predicates to validate form input

-- check that the input Text is non-empty
checkText :: Text -> Bool
checkText "" = False
checkText _  = True

-- -----------------------------------------------------------------------------
-- * Define a form

-- creates a form with a single textarea field
form :: Monad m => Form Text m TextBlob
form = TextBlob
  <$> "textarea" .: check "Must not be empty" checkText (text Nothing)

-- -----------------------------------------------------------------------------
-- * Create compiled Heist splices to export

textAreaSplices :: MonadSnap n => Splices (Splice n)
textAreaSplices = makeFormSplices "textArea" "textAreaTabs" form asText

-- -----------------------------------------------------------------------------
-- * Create a handler to render the Heist template

textAreaHandler :: AppHandler ()
textAreaHandler = cRender "/forms/textarea"

