--- cryptol/REPL/Haskeline.hs.orig	2001-09-09 01:46:40 UTC
+++ cryptol/REPL/Haskeline.hs
@@ -128,7 +128,7 @@ setHistoryFile :: Settings REPL -> IO (Settings REPL)
 setHistoryFile ss =
   do dir <- getHomeDirectory
      return ss { historyFile = Just (dir </> ".cryptol_history") }
-   `X.catch` \(SomeException {}) -> return ss
+   `X.catch` \(X.SomeException {}) -> return ss
 
 -- | Haskeline settings for the REPL.
 replSettings :: Bool -> Settings REPL
