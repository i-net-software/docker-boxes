FROM inetsoftware/windows-chocolatey
MAINTAINER contact@inetsoftware.de

EXPOSE 22

#This monitor is from Microsoft 
ADD ServiceMonitor.exe /ServiceMonitor.exe

# disable password policies
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
    secedit /export /cfg c:\secpol.cfg ; \
    (gc C:\secpol.cfg).replace(\"PasswordComplexity = 1\", \"PasswordComplexity = 0\") | Out-File C:\secpol.cfg ; \
    secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY ; \
    rm -force c:\secpol.cfg -confirm:$false \
    ; "

# set the administrator active
# create a jenkins user
# set a well know password
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
    net user Administrator /active:yes ; \
    net user jenkins /add /expires:never ; \
    net localgroup Administrators /add jenkins ; \
    Get-WmiObject win32_useraccount | Foreach-Object { \
    ([adsi](\"WinNT://\"+$_.caption).replace(\"\\\",\"/\")).SetPassword(\"jenkins\") } \
    ; "

# Make the passwords of the currently existing users to never expire.
RUN WMIC USERACCOUNT SET PasswordExpires=FALSE

RUN mkdir C:\jenkins

#install openssh
RUN choco install openssh -params "/SSHServerFeature"

ADD true.bat /WINDOWS/system32/true.bat

# run endlessly
CMD ["C:\\ServiceMonitor.exe", "sshd"]
