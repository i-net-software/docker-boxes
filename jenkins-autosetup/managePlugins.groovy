import jenkins.model.*
import hudson.util.VersionNumber
import java.util.logging.Logger

def logger = Logger.getLogger("")
def installed = false
def initialized = false

def pluginParameter = new File('/usr/share/jenkins/ref/plugins.txt').text
def plugins = pluginParameter.split()
logger.info("" + plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
uc.updateAllSites()

plugins.each {
    def (pluginName, version) = it.tokenize( ':' )
    def checkVersion = new VersionNumber(!version?"latest":version)
  
    logger.info("Checking " + pluginName + " Version:" + checkVersion)
    def pl = pm.getPlugin(pluginName);
    if (!pl || (pl.hasUpdate() && ( pl.isOlderThan(checkVersion) || checkVersion=="latest" ) ) ) {
        logger.info("\tLooking at UpdateCenter for: " + pluginName)
        if (!initialized) {
            uc.updateAllSites()
            initialized = true
        }

        def plugin = uc.getPlugin(pluginName)
        if (plugin) {
            logger.info( "\t" +(pl && pl.hasUpdate()?"Updating ":"Installing ") + pluginName)
            plugin.deploy()
            installed = true
        }
    }
}
    
if (installed) {
    logger.info("Plugins installed, initializing a restart!")
    instance.save()
    instance.doSafeRestart()
}