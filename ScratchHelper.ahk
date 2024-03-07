#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; トレイメニューとアイコンの設定
Menu, tray, NoStandard
Menu, tray, Add, Exit, GuiClose
TrayIcon := "img/th.png"
IfExist, %TrayIcon%
  Menu, tray, Icon, %TrayIcon%

; GUI作成
Application_logo := "img/logo_sm.png"
IfExist, %Application_logo%
{
  GUI, Add, Picture,, %Application_logo%
} Else {
  GUI, Add, Text,, Scratch Helper
}
GUI, +AlwaysOnTop -MaximizeBox -MinimizeBox

; GUI表示位置の決定
; タスクトレイを除いたディスプレイ解像度を取得
ScreenWidth := A_ScreenWidth
SceenHeight := GetScreenHeightWithoutTasktray()

; GUIのウィンドウのサイズを取得
Gui,Show,Hide AutoSize, Scratch Helper
Gui,+LastFound
WinGetPos,Xpos,Ypos, MainWinWidth, MainWinHeight

; ウインドウのサイズから表示位置を計算
Xpos := ScreenWidth - MainWinWidth
Ypos := SceenHeight - MainWinHeight

; GUIの表示
GUI, show,x%Xpos% y%Ypos%, Scratch Helper
Return

; GUIを閉じる動作定義
GuiClose:
GuiEscape:
ExitApp


; テキストを選択したときにツールチップを表示する
vk1D & c::
  Clipboard := "" ; クリップボードを空にする
  Sleep, 100
  Send, ^c
  ClipWait
  If (IsZenkaku(Clipboard)){
    result := "全角文字が含まれてるよ"
  } else {
    result := "半角文字だけだよ"
  }
  ToolTip, %result%
  Sleep 1000
  ToolTip
  Return

;+-------------------------------------------------------------------------------------------------------------
; 全角文字を含むか判定
;	引数：判定する文字列
;	返り値：True or False
;+-------------------------------------------------------------------------------------------------------------
IsZenkaku(s) {
  Loop, Parse, s
    if (Asc(A_LoopField) > 255)
      return true
  return false
}
;+-------------------------------------------------------------------------------------------------------------
; タスクトレイの高さを取得
;	引数：なし
;	返り値：タスクトレイの高さ
;+-------------------------------------------------------------------------------------------------------------
GetTasktrayHeight(){
  WinGetPos, Xpos, Ypos, TaskTrayWidth, TaskTrayHeight, ahk_class Shell_TrayWnd
  return TaskTrayHeight
}

;+-------------------------------------------------------------------------------------------------------------
; タスクトレイを除いたディスプレイの高さを取得
;	引数：なし
;	返り値：タスクトレイを除いたディスプレイの高さ
;+-------------------------------------------------------------------------------------------------------------
GetScreenHeightWithoutTasktray(){
  return A_ScreenHeight - GetTasktrayHeight()
}



;----------------------------
; 数字及び-を常に半角で入力
;----------------------------
1::Send,{U+0031}
2::Send,{U+0032}
3::Send,{U+0033}
4::Send,{U+0034}
5::Send,{U+0035}
6::Send,{U+0036}
7::Send,{U+0037}
8::Send,{U+0038}
9::Send,{U+0039}
0::Send,{U+0030}
-::SendHK("{U+002D}")

;----------------------------
;数字を常に半角で入力終了
;----------------------------

;+-------------------------------------------------------------------------------------------------------------
; IMEがONのときでも半角文字をSend
;	引数：Keys
;	返り値：なし
;+-------------------------------------------------------------------------------------------------------------
SendHK(Keys){
  ime_mode := IME_GET()
  IME_SET(0)
  Send, %Keys%
  IME_SET(ime_mode)
  Return
}
