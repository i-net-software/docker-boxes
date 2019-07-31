ARG REGISTRY
ARG SDK_TAG=latest
FROM ${REGISTRY}inetsoftware/windows-chocolatey:${SDK_TAG}
LABEL maintainer contact@inetsoftware.de

EXPOSE 22

#This monitor is from Microsoft 
ADD ServiceMonitor.exe /ServiceMonitor.exe

ADD true.bat /WINDOWS/system32/true.bat

RUN mkdir C:\jenkins

#install openssh
RUN choco install openssh -params '/SSHServerFeature'

# Temporary Hack for the 50-char-paste-bug see: https://github.com/moby/moby/issues/29646
# TODO: Remove.
WORKDIR "/Program Files"
RUN rd /S /Q WindowsPowerShell\Modules\PSReadLine
WORKDIR /

# Reset the shell.
SHELL ["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

# set the administrator active
# create a jenkins user
RUN net user Administrator /active:yes ; \
    net user jenkins /add /expires:never ; \
    net localgroup Administrators /add jenkins

# disable password policies
# ADD changepolicy.bat /
# RUN echo J5nk1ns | runas /user:Administrator C:\changepolicy.bat

#    Set-Content -Path 'C:\secpol.cfg' -Value "[Unicode]`n[System Access]`nPasswordComplexity = 0" \
#    Set-Content -Path 'C:\secpol.bat' -Value "secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY" \

# RUN secedit /export /cfg c:\secpol.cfg ; \
#    (gc C:\secpol.cfg).replace('PasswordComplexity = 1', 'PasswordComplexity = 0') | Out-File C:\secpol.cfg ; \
#    secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY ;

# set a well know password, ignore sshd account
RUN Get-WmiObject win32_useraccount | Where-Object { $_.name -ne 'ssh' } | Foreach-Object { \
    echo $_.caption ; \
    ([adsi]('WinNT://'+$_.caption).replace('\', '/')).SetPassword('J5nk1ns') \
    } ; 
# '

# Set Powershell as default
# see https://github.com/PowerShell/Win32-OpenSSH/wiki/DefaultShell
RUN . "$Env:ProgramFiles\OpenSSH-Win64\Set-SSHDefaultShell.ps1" \
    -PathSpecsToProbeForShellEXEString '$Env:ProgramFiles\PowerShell\*\pwsh.exe;$Env:ProgramFiles\PowerShell\*\Powershell.exe;c:\windows\system32\windowspowershell\v1.0\powershell.exe' \
    -SSHDefaultShellCommandOption '-ExecutionPolicy Bypass -Command'

# RESET SHELL
SHELL ["cmd", "/S", "/C"]

# Make the passwords of the currently existing users to never expire.
RUN WMIC USERACCOUNT SET PasswordExpires=FALSE

# run endlessly
CMD ["C:\\ServiceMonitor.exe", "sshd"]
