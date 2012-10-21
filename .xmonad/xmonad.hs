import XMonad
import System.IO

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.PerWorkspace
import XMonad.Layout.LayoutHints
import XMonad.Layout.Simplest
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)

main = do
    --xmonad $ defaultConfig
    --xmproc <- spawnPipe "xmobar"
    dzenLeftBar <- spawnPipe myDzenStatus
    dzenRightBar <- spawnPipe myDzenConky
    xmonad $ defaultConfig
        { borderWidth         = 1
        , startupHook         = myStartupHook
        , terminal            = myTerminal
        , workspaces          = myWorkspaces
        , normalBorderColor   = "#cccccc"
        , focusedBorderColor  = "#ff0000"
        , manageHook = manageDocks <+> manageHook defaultConfig
        --, layoutHook = avoidStruts  $  layoutHook defaultConfig
        , layoutHook = myLayout
        , logHook             = myLogHook dzenLeftBar
        --, logHook = dynamicLogWithPP xmobarPP
        --    { ppOutput = hPutStrLn xmproc
        --    , ppTitle = xmobarColor "green" "" . shorten 50
        --    }
        , modMask = mod4Mask -- Rebind Mod to the Windows key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "slock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot -e 'mv $f ~/screen_shots/'")
        , ((0, 0x1008ff13), spawn "amixer set Master 1+")
        , ((0, 0x1008ff11), spawn "amixer set Master 1-")
        , ((0, 0x1008ff12), spawn "amixer set Master toggle")
        ]

-- This is so matlab will act in a sane manner with a tiling WM
myStartupHook = do
    setWMName "LG3D"

defaultLayouts = avoidStruts(tiled ||| Mirror tiled ||| Full)
  where  
    -- default tiling algorithm partitions the screen into two panes  
    tiled = spacing 5 $ Tall nmaster delta ratio  
        
    -- The default number of windows in the master pane  
    nmaster = 1  
                            
    -- Default proportion of screen occupied by master pane  
    ratio = 1/2
                                           
    -- Percent of screen to increment by when resizing panes  
    delta = 2/100  

-- Define layouts for specific workspaces
nobordersLayout = noBorders $ avoidStruts(Full)

videoSpace = onWorkspace "6:video" ( noBorders Simplest )
codeSpace = onWorkspace "3:code" nobordersLayout

myLayout = videoSpace $ codeSpace $ defaultLayouts

myTerminal = "urxvt"

myWorkspaces = ["1:main", "2:web", "3:code", "4:chat", "5:music", "6:video", "7","8","9"]

-- Forward the window information to the left dzen bar and format it.
myLogHook h = dynamicLogWithPP $ myDzenPP { ppOutput = hPutStrLn h }

myDzenStatus = "dzen2 -x '0' -w '1000' -ta 'l'" ++ myDzenStyle
myDzenConky = "conky -c ~/.xmonad/.conky_dzen | dzen2 -x '800' -w '566' -ta 'r'" ++ myDzenStyle

-- Bar 20px high and colors
myDzenStyle = " -h '17' -y '0' -fg '#FFFFFF' -bg '#000000'"

-- Very plain formatting, non-empty workspaces are highlighted,
-- urgent workspaces (e.g. active IM window) are highlighted in red
myDzenPP  = dzenPP
  { ppCurrent = dzenColor "#3399ff" "" . wrap " " " "
  , ppHidden  = dzenColor "#dddddd" "" . wrap " " " "
  , ppHiddenNoWindows = dzenColor "#777777" "" . wrap " " " "
  , ppUrgent  = dzenColor "#ff0000" "" . wrap " " " "
  , ppSep     = "  "
  , ppLayout  = \y -> ""
  , ppTitle   = dzenColor "green" "" . wrap " " " "
  }

