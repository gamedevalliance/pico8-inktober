if WinExist("PICO-8")
    WinActivate ; use the window found above
    SendInput, ^{r}
    WinActivate, ahk_exe Code.exe
return
