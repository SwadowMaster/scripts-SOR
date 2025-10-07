server-config powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/AlejandroSantana/Script-SOR/main/server-config.bat -OutFile %temp%\server-config.bat; %temp%\server-config.bat"
client-config powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/AlejandroSantana/Script-SOR/main/client-config.bat -OutFile %temp%\server-config.bat; %temp%\server-config.bat"
