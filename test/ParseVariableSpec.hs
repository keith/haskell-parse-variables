module ParseVariableSpec (main, spec) where

import Test.Hspec
import ParseVariable

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    describe "parseVariable" $ do
        it "handles unquoted variables" $ do
            parseVariable "FOO=bar\n" `shouldBe` Just ("FOO", "bar")

        it "handles quoted variables" $ do
            parseVariable "FOO=\"bar\"\n" `shouldBe` Just ("FOO", "bar")
            parseVariable "FOO='bar'\n" `shouldBe` Just ("FOO", "bar")

        it "handles empty values" $ do
            parseVariable "FOO=\n" `shouldBe` Just ("FOO", "")

        it "handles empty quoted values" $ do
            parseVariable "FOO=\"\"\n" `shouldBe` Just ("FOO", "")
            parseVariable "FOO=''\n" `shouldBe` Just ("FOO", "")

        it "handles underscored variables" $ do
            parseVariable "FOO_BAR=baz\n" `shouldBe` Just ("FOO_BAR", "baz")

        it "handles lines prefixed with `export'" $ do
            parseVariable "export FOO=bar\n" `shouldBe` Just ("FOO", "bar")

        it "handles different quotes" $ do
            parseVariable "FOO=\"bar'\n" `shouldBe` Nothing

        it "handles trailing comments" $ do
            parseVariable "FOO=\"bar\"# trailing comment\n" `shouldBe` Just ("FOO", "bar")

        it "treats leading spaces as invalid" $ do
            parseVariable "  FOO=bar\n" `shouldBe` Nothing

        it "treats spaces around equals as invalid" $ do
            parseVariable "FOO = bar\n" `shouldBe` Nothing

        it "treats unquoted spaces as invalid" $ do
            parseVariable "FOO=bar baz\n" `shouldBe` Nothing

        it "treats unbalanced quotes as invalid" $ do
            parseVariable "FOO=\"bar\n" `shouldBe` Nothing
            parseVariable "FOO='bar\n" `shouldBe` Nothing
            parseVariable "FOO=bar\"\n" `shouldBe` Nothing
            parseVariable "FOO=bar'\n" `shouldBe` Nothing
