ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-chocolatey
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

# disable password policies
RUN secedit /export /cfg c:\secpol.cfg ; \
    (gc C:\secpol.cfg).replace('PasswordComplexity = 1', 'PasswordComplexity = 0') | Out-File C:\secpol.cfg ; \
    secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY ; \
    rm -force c:\secpol.cfg -confirm:$false \
    ;

# set the administrator active
# create a jenkins user
RUN net user Administrator /active:yes ; \
    net user jenkins /add /expires:never ; \
    net localgroup Administrators /add jenkins

# set a well know password, ignore sshd account
RUN Get-WmiObject win32_useraccount | Where-Object { $_.name -ne 'sshd' } | Foreach-Object { \
    echo $_.caption ; \
    ([adsi]('WinNT://'+$_.caption).replace('\', '/')).SetPassword('jenkins') \
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
