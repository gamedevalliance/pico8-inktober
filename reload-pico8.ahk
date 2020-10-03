if WinExist("ahk_exe pico8.exe")
    WinActivate ; use the window found above
    SendInput, ^{r}
    WinActivate, ahk_exe Code.exe
return
