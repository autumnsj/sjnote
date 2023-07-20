@echo off

set FOLDER=.
set FILE1=_sidebar.md
set FILE2=readme.md

forfiles /p %FOLDER% /s /m %FILE1% /c "cmd /c del @path"
forfiles /p %FOLDER% /s /m %FILE2% /c "cmd /c del @path"