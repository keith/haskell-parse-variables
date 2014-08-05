module ParseVariable where

import Text.Parsec
import Text.Parsec.String

type Variable = (String, String)

parseVariable :: String -> Maybe Variable
parseVariable x =
  case parse lineParser "" x of
    Left _ -> Nothing
    Right x -> Just x

lineParser :: Parser Variable
lineParser = do
  optional $ string "export "
  name <- many1 $ letter <|> char '_'
  oneOf "="
  value <- quotedString <|> valueString
  optional commentString
  newline
  return (name, value)

commentString :: Parser String
commentString = do
  skipMany $ char ' '
  oneOf "#"
  comment <- many $ letter <|> (char ' ')
  skipMany $ char ' '
  return comment

valueString :: Parser String
valueString = many $ try (escaped ' ') <|> (noneOf "\n\"' ")

escaped :: Char -> Parser Char
escaped c = string ("\\" ++ [c]) >> return c

quotedString :: Parser String
quotedString = do
  quote <- oneOf "\"'"
  content <- many $ try (escaped quote) <|> (noneOf $ quote:"\n ")
  char quote
  return content
