FROM windowsservercore

# install chocolaty
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

#allow global confirmation for choco
RUN choco feature enable -n allowGlobalConfirmation

# install java
RUN choco install -y jdk8

#install ssh
#register service and start it
RUN choco install win32-openssh

RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
	Set-Location \"$env:ProgramFiles\OpenSSH-Win64\" ; \
	.\ssh-keygen.exe -A ; \
	.\install-sshd.ps1 ; \
	Set-Service -Name \"SSHD\" -Description \"SSH Service for Windows\" -StartupType Automatic ; \
	Start-Service SSHD"

EXPOSE 22

CMD powershell
