
-- needed software:
-- conky dzen2 xdotool  -- for status bar
-- feh                  -- for setting background
-- xrander              -- for multi-head
-- gmrun                -- for quick launch
-- amixer               -- for volume control(in alsa-utils)
-- scrot                -- for screenshot (gnome-screenshot -a can not show border clearly)
-- udiskie              -- for automount.
-- trayer               -- for trayer support( install trayer-srg for multi-monitor support)

import XMonad
import XMonad.Actions.CycleWindows -- classic alt-tab
import XMonad.Actions.CycleWS      -- cycle thru WS', toggle last WS
import XMonad.Actions.DwmPromote   -- swap master like dwm
import XMonad.Hooks.DynamicLog     -- statusbar
import XMonad.Hooks.EwmhDesktops   -- fullscreenEventHook fixes chrome fullscreen
import XMonad.Hooks.ManageDocks    -- dock/tray mgmt
import XMonad.Hooks.UrgencyHook    -- window alert bells
import XMonad.Layout.Named         -- custom layout names
import XMonad.Layout.NoBorders     -- smart borders on solo clients
import XMonad.Util.EZConfig        -- append key/mouse bindings
import XMonad.Util.Run(spawnPipe)  -- spawnPipe and hPutStrLn
import System.IO                   -- hPutStrLn scope
import Control.Monad(liftM2)
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import XMonad.Hooks.ManageHelpers(doFullFloat)
-- for volume control ...
import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W   -- manageHook rules


main = do
  -- I use two dzen bars, the left one contains the Xomand workspaces
  -- and title etc., eth right one contains the output from conky
  -- with some stats etc.
  status <- spawnPipe myDzenStatus
  conky  <- spawnPipe myDzenConky

  xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig {
    terminal      = "xfce4-terminal"
    , modMask     = myModMask
    , workspaces  = myWorkspaces
    , borderWidth = 3
    -- , normalBorderColor  = "#dddddd"
    -- , focusedBorderColor = "#0000ff"

    , layoutHook  = myLayout
    , logHook     = myLogHook status
    , manageHook  = manageDocks <+> myManageHook <+> manageHook defaultConfig
    , startupHook = myStartupHook
    , focusFollowsMouse = False
    } `additionalKeys` myKeys

myModMask = mod4Mask

myWorkspaces =
  [ "a"
  , "o"
  , "e"
  , "u"
  , "i"
  , "d"
  ]

myStartupHook = do
    -- set no beep
    spawn "xset -b"
    -- set default cursor
    spawn "xsetroot -cursor_name left_ptr"
    -- system tray.
    spawn "pgrep -x trayer || trayer --edge top --align right --widthtype pixel --width 160 --transparent true --alpha 0 --tint 0x1A1918 --heighttype pixel --height 24 --padding 1"
    -- input method
    spawn "pgrep -x fcitx || fcitx"
    -- modify by `xrandr -q`
    spawn "/usr/bin/xrandr --auto --output eDP1 --primary --auto --output HDMI1 --right-of eDP1 --auto --output VGA1 --right-of eDP1"
    -- xautolock daemons
    spawn "pgrep -x xautolock || xautolock -time 10 -locker sxlock -killtime 120 -killer \"systemctl hibernate\""
    -- lock after suspend or hibernate
    -- spawn "pgrep -x xss-lock || xss-lock -- /usr/bin/sxlock"
    -- automount
    spawn "pgrep -x udiskie || udiskie -2"
    -- background setting
    spawn "sleep 0.1; /usr/bin/feh --bg-scale ~/dotfile/wallpaper/jzbq.jpeg"
    -- screensaver daemons
    -- spawn "pgrep -x xscreensaver || xscreensaver"
    -- spawn "pgrep -x xautolock || xautolock -time 5 -locker \"xscreensaver-command -lock\""
    spawn "pgrep -x xautolock || xautolock -time 5 -locker \"cinnamon-screensaver-command -l\""
    -- terminal
    spawn "pgrep -x xfce4-terminal || xfce4-terminal"
    spawn "pgrep -x tilda || tilda -h"
    -- firefox
    spawn "pgrep -x firefox || firefox"
    -- thunderbird
    -- spawn "pgrep -x thunderbird || thunderbird"
    -- pidgin
    -- spawn "pgrep -x pidgin || sleep 5 && pidgin"
    -- telegram
    spawn "pgrep -x telegram || telegram"

myManageHook = composeAll . concat $
    [ [ className   =? "Firefox" <&&> stringProperty "WM_WINDOW_ROLE" =? "browser" --> doF(W.shift "o")]
    , [ className   =? "Thunderbird" --> doF(W.shift "e")]
    , [ className   =? "Gvim" --> viewShift "u"]
    , [ className   =? "thunar" --> doF(W.shift "i")]
    , [ className   =? "nemo" --> doF(W.shift "i")]
    , [ className   =? c --> doF(W.shift "d") | c <- ircApps]
    , [ resource    =? "TeamViewer.exe" <&&> title =? "Computers & Contacts" --> doIgnore]
    ]
  where ircApps       = ["Pidgin", "Virt-viewer", "Telegram"]
        viewShift     = doF . liftM2 (.) W.greedyView W.shift

myScreenshot = "scrot" ++ myScreenshotOptions
myScreenshotArea = "sleep 0.3s; scrot -s" ++ myScreenshotOptions
myScreenshotOptions = " -e 'mv $f /tmp/%Y%m%dT%H%M%S_$wx$h_scrot.png'"

myKeys =
  [((myModMask, xK_a), windows $ W.greedyView "a")
  , ((myModMask, xK_o), windows $ W.greedyView "o")
  , ((myModMask, xK_e), windows $ W.greedyView "e")
  , ((myModMask, xK_u), windows $ W.greedyView "u")
  , ((myModMask, xK_i), windows $ W.greedyView "i")
  , ((myModMask, xK_d), windows $ W.greedyView "d")
  -- run command
  , ((mod1Mask, xK_F2), spawn "gmrun")
  , ((myModMask, xK_p), spawn "gmrun")
  -- classic alt-tab behaviour
  , ((mod1Mask, xK_Tab), cycleRecentWindows [xK_Alt_L] xK_Tab xK_Tab )
  -- lock screen
  , ((controlMask .|. mod1Mask, xK_l), spawn "dm-tool lock")
  -- print screen
  , ((controlMask, xK_Print), spawn myScreenshotArea)
  , ((0, xK_Print), spawn myScreenshot)
  -- reboot or shutdown
  -- TODO add comfirm box.
  , ((controlMask .|. shiftMask, xK_Delete), spawn "systemctl reboot")
  , ((controlMask .|. shiftMask, xK_Insert), spawn "systemctl poweroff")
  -- applications key map
  , ((myModMask .|. shiftMask, xK_w), spawn "firefox")
  , ((myModMask .|. shiftMask, xK_f), spawn "nemo --no-desktop")
  , ((myModMask .|. shiftMask, xK_m), spawn "thunderbird")
  , ((myModMask .|. shiftMask, xK_p), spawn "pidgin")
  , ((myModMask .|. shiftMask, xK_v), spawn "virt-viewer -c qemu:///system win7")
  -- volume control
  , ((0 , xF86XK_AudioLowerVolume), spawn "amixer set Master 4%-")
  , ((0 , xF86XK_AudioRaiseVolume), spawn "amixer set Master 4%+")
  , ((0 , xF86XK_AudioMute), spawn "amixer set Master toggle")
  , ((0 , xF86XK_AudioPrev), spawn "mpc prev")
  , ((0 , xF86XK_AudioNext), spawn "mpc next")
  , ((0 , xF86XK_AudioPlay), spawn "mpc toggle")
  , ((0 , xF86XK_AudioStop), spawn "mpc stop")
  -- undo float windows.
  , ((myModMask, xK_t ), withFocused $ windows . W.sink)
  ]

-- the default layout is fullscreen with smartborders applied to all
myLayout = smartBorders ( full ||| mtiled ||| tiled )
  where
    full    = named "X" $ Full
    mtiled  = named "M" $ Mirror tiled
    tiled   = named "T" $ Tall 1 (5/100) (2/(1+(toRational(sqrt(5)::Double))))
    fullL   = noBorders $ Full

-- Statusbar
--
myLogHook h = dynamicLogWithPP $ myDzenPP { ppOutput = hPutStrLn h }

myDzenStatus = "dzen2 -xs 1 -w 1120 -ta 'l'" ++ myDzenStyle
myDzenConky  = "conky -c ~/.xmonad/conkyrc | dzen2 -xs 1 -x 1120 -w 640 -ta 'r'" ++ myDzenStyle
myDzenStyle  = " -u -h '24' -fg '#777777' -bg '#222222' -fn 'arial:bold:size=11'"

myDzenPP  = dzenPP
    { ppCurrent = dzenColor "#3399ff" "" . wrap " " ""
    , ppHidden  = dzenColor "#dddddd" "" . wrap " " ""
    , ppHiddenNoWindows = dzenColor "#777777" "" . wrap " " ""
    , ppUrgent  = dzenColor "#ff0000" "" . wrap " " ""
    , ppSep     = " "
    , ppLayout  = dzenColor "#aaaaaa" "" . wrap "^ca(1,xdotool key super+space)|" "|^ca()"
    , ppTitle   = dzenColor "#ffffff" ""
                    . wrap "^ca(1,xdotool key super+k)^ca(2,xdotool key super+shift+c)"
                           "                          ^ca()^ca()" . shorten 80 . dzenEscape
    }

