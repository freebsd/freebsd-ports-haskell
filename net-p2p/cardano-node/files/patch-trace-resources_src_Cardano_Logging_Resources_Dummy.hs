--- trace-resources/src/Cardano/Logging/Resources/Dummy.hs.orig	2021-12-20 17:50:47 UTC
+++ trace-resources/src/Cardano/Logging/Resources/Dummy.hs
@@ -1,20 +1,20 @@
 module Cardano.Logging.Resources.Dummy
     (
-      readResourceStatsInternal
+      readRessoureStatsInternal
     ) where
 
-import           Cardano.Logging.Resources
+import           Cardano.Logging.Resources.Types
 import           Data.Word
 import qualified GHC.Stats as GhcStats
 import           System.CPUTime
 
 
-readResourceStatsInternal :: IO ResourceStats
-readResourceStatsInternal = do
+readRessoureStatsInternal :: IO (Maybe ResourceStats)
+readRessoureStatsInternal = do
   cpu <- getCPUTime
   rts <- GhcStats.getRTSStats
-  pure $
-    ResourceStats
+  pure $ Just $
+    Resources
     { rCentiCpu   = intToCenti cpu
     , rCentiGC    = nsToCenti $ GhcStats.gc_cpu_ns rts
     , rCentiMut   = nsToCenti $ GhcStats.mutator_cpu_ns rts
@@ -23,6 +23,7 @@ readResourceStatsInternal = do
     , rAlloc      = GhcStats.allocated_bytes rts
     , rLive       = GhcStats.gcdetails_live_bytes $ GhcStats.gc rts
     , rRSS        = 0
+    , rHeap       = 0
     , rCentiBlkIO = 0
     , rThreads    = 0
     }
