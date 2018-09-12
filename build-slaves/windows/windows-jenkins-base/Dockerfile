ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-chocolatey
LABEL maintainer contact@inetsoftware.de

EXPOSE 22

#This monitor is from Microsoft 
ADD ServiceMonitor.exe /ServiceMonitor.exe

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

# set a well know password
RUN Get-WmiObject win32_useraccount | Foreach-Object { \
    echo $_.caption \
    ([adsi]('WinNT://'+$_.caption).replace('\', '/')).SetPassword('jenkins') \
    } ;

SHELL ["cmd", "/S", "/C"]

# Make the passwords of the currently existing users to never expire.
RUN WMIC USERACCOUNT SET PasswordExpires=FALSE

RUN mkdir C:\jenkins

#install openssh
RUN choco install openssh -params '/SSHServerFeature'

ADD true.bat /WINDOWS/system32/true.bat

# Temporary Hack for the 50-char-paste-bug see: https://github.com/moby/moby/issues/29646
# TODO: Remove.
WORKDIR "/Program Files"
RUN rd /S /Q WindowsPowerShell\Modules\PSReadLine
WORKDIR /

# run endlessly
CMD ["C:\\ServiceMonitor.exe", "sshd"]
