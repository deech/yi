module Yi.Config.Default.Fltk (configureFltk) where

import Lens.Micro.Platform ((.=))
import Yi.Frontend.Fltk    (buildGui)
import Yi.Config.Lens      (startFrontEndA)
import Yi.Config.Simple    (ConfigM)

configureFltk :: ConfigM ()
configureFltk = startFrontEndA .= buildGui
