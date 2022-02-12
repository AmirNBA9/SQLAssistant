@SET /P message="Please Type the commit message: "

git.exe pull -v "origin"
git commit --all --message "%message%"
git.exe push -v "origin" 

pause

