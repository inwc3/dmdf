SET VERSION=%1

del "F:\Projekte\dmdf\maps\releases\en\Dornheim%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\releases\Dornheim\Dornheim%VERSION%.w3x" --do "F:\Projekte\dmdf\maps\releases\en\Dornheim%VERSION%.w3x" --checkscriptstuff --exit
del "F:\Projekte\dmdf\maps\releases\en\DH.w3x"
copy "F:\Projekte\dmdf\maps\releases\en\Dornheim%VERSION%.w3x" "F:\Projekte\dmdf\maps\releases\en\DH.w3x"