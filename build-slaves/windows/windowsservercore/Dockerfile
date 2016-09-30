FROM microsoft/windowsservercore

# install chocolaty
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

# allow global confirmation for choco
RUN choco feature enable -n allowGlobalConfirmation

# install ssh
# register service and start it
RUN choco install win32-openssh

# Set up the ssh service,
# set a default password for the users in the virtual machine
# allow the admin to log in (boooh)
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
    Set-Location \"$env:ProgramFiles\OpenSSH-Win64\" ; \
    .\ssh-keygen.exe -A ; \
    .\install-sshd.ps1 ; \
    Set-Service -Name \"SSHD\" -Description \"SSH Service for Windows\" -StartupType Automatic ; \
    Start-Service SSHD ; \
    net user administrator /active:yes ; \
    Get-WmiObject win32_useraccount | Foreach-Object { \
    ([adsi](\"WinNT://\"+$_.caption).replace(\"\\\",\"/\")).SetPassword(\"JenkinsPassword1\") \
    }"

EXPOSE 22

# install java
RUN choco install -y jdk8

# install gradle
RUN choco install gradle -version 2.14.1

#install git
RUN choco install git

#install git
RUN choco install svn

# run endlessly
CMD powershell
