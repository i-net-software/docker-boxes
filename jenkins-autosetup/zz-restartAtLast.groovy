import jenkins.model.*
import jenkins.install.InstallState

def instance = Jenkins.getInstance()
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)