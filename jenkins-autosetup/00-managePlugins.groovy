import jenkins.model.*
import hudson.util.VersionNumber
import java.util.logging.Logger

def logger = Logger.getLogger("")
def installed = false

def env = System.getenv()
def pluginParameter = new File('/usr/share/jenkins/ref/plugins.txt').text
def plugins = pluginParameter.split()
logger.info("" + plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
def updateJenkins = !!(env['UPDATE_JENKINS']?:false)

logger.info("Automatic update of fixed Jenkins Plugin versions to 'latest' is " + (updateJenkins?'enabled':'disabled') + '.')
def shouldUpdate = { plugin, checkVersion ->
    return ( updateJenkins && plugin.isNewerThan(checkVersion.toString()) ) || checkVersion.toString()=="latest"
}

uc.updateAllSites()
plugins.each {
    def (pluginName, version) = it.tokenize( ':' )
    def checkVersion = new VersionNumber(!version?"latest":version)
  
    logger.info("Checking '" + pluginName + "' Version: '" + checkVersion + "'")
    def pl = pm.getPlugin(pluginName);
    if (!pl || (pl.hasUpdate() && shouldUpdate( pl, checkVersion) ) ) {
        logger.info("\tLooking at UpdateCenter for: " + pluginName)

        def plugin = uc.getPlugin(pluginName, checkVersion)
        if (plugin && shouldUpdate( plugin, checkVersion) ) {
            logger.info( "\t" +(pl && pl.hasUpdate()?"Updating ":"Installing ") + pluginName)
            def exec = plugin.deploy()
            while( !exec.isDone() ) {
                sleep(100)
            }

            logger.info( "\tDone for " + pluginName)
            installed = true
        } else {
            logger.info( "\tDid not update " + pluginName )
        }
    }
}
    
if (installed) {
    logger.info("Plugins installed, initializing a restart!")
    instance.save()
    
    // Just do it. Plugins are the very earliest.
    if ( uc.isRestartRequiredForCompletion() ) {
        instance.restart()
    }
}