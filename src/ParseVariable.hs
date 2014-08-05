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
  name <- many1 $ choice [letter, (char '_')]
  oneOf "="
  value <- doubleQuotedString <|> singleQuotedString <|> valueString
  newline
  return (name, value)

valueString :: Parser String
valueString = many $ noneOf "\n\"' "

doubleQuotedString :: Parser String
doubleQuotedString = do
  char '"'
  content <- many $ noneOf "\"\n "
  char '"'
  return content

singleQuotedString :: Parser String
singleQuotedString = do
  char '\''
  content <- many $ noneOf "'\n "
  char '\''
  return content
