module ParseVariable where

import Text.Parsec
import Text.Parsec.String

type Variable = (String, String)

parseVariable :: String -> Maybe Variable
parseVariable x =
  case parseLine x of
    Left _ -> Nothing
    Right x -> Just x

parseLine :: String -> Either ParseError Variable
parseLine = parse lineParser ""

lineParser :: Parser Variable
lineParser = do
  optional $ string "export "
  name <- many1 $ letter <|> char '_'
  oneOf "="
  value <- quotedString <|> valueString
  newline
  return (name, value)

valueString :: Parser String
valueString = many $ noneOf "\n\"' "

quotedString :: Parser String
quotedString = do
  quote <- oneOf "\"'"
  content <- many $ noneOf $ quote:"\n "
  char quote
  return content
