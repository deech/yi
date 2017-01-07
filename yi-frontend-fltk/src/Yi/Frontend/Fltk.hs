{-# LANGUAGE OverloadedStrings #-}
module Yi.Frontend.Fltk (buildGui) where
import qualified Yi.UI.Common as Common
import           Yi.Editor
import           Yi.Types
import           Graphics.UI.FLTK.LowLevel.FLTKHS
import           System.FilePath
import           Data.Text as T
import qualified Graphics.UI.FLTK.LowLevel.FL as FL
import qualified Data.List.PointedList.Circular as PL
import           Data.IORef

mkUI :: UI -> Common.UI Editor
mkUI ui = Common.dummyUI
    { Common.main          = main ui
    , Common.end           = const shutdown
    , Common.suspend       = hide (mainWindow ui)
    , Common.refresh       = refresh ui
    , Common.layout        = doLayout ui
    , Common.reloadProject = const reloadProject
    }

data UI = UI
  {
    mainWindow :: Ref DoubleWindow
  , tabCache ::  IORef TabInfo
  }

type TabCache = PL.PointedList TabInfo

data TabInfo = TabInfo
  {
    label :: T.Text
  , editor :: Ref TextEditor
  }

main :: UI -> IO ()
main ui = do
  showWidget (mainWindow ui)
  _ <- FL.run
  return ()

shutdown :: IO ()
shutdown = return ()

refresh :: UI -> Editor -> IO ()
refresh _ _ = return ()

doLayout :: UI -> Editor -> IO Editor
doLayout _ e = return e

reloadProject :: IO ()
reloadProject = return ()

buildGui :: UIBoot
buildGui editorConfig eventHandler  actionHandler editor = do
  mainWindow <- doubleWindowNew (Size (Width 700) (Height 800)) Nothing (Just "Yi")
  begin mainWindow
  tabs <- tabsNew (toRectangle (0,0,700,750)) Nothing
  begin tabs
  _ <- textEditorNew (toRectangle (0,20,700,720)) (Just "tab1")
  _ <- textEditorNew (toRectangle (0,20,700,720)) (Just "tab2")
  _ <- textEditorNew (toRectangle (0,20,700,720)) (Just "tab3")
  _ <- textEditorNew (toRectangle (0,20,700,720)) (Just "tab4")
  end tabs
  end mainWindow
  setResizable tabs (Just mainWindow)
  setResizable mainWindow (Just mainWindow)
  return (mkUI (UI mainWindow undefined))
