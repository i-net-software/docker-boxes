import jenkins.model.*
import hudson.util.VersionNumber
import java.util.logging.Logger
import jenkins.RestartRequiredException;

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
    return checkVersion.toString()=="latest" ||
            ( updateJenkins &&
                ( plugin instanceof hudson.model.UpdateSite.Plugin ? plugin.isNewerThan(checkVersion.toString()) : !plugin.isOlderThan(checkVersion) )
            )
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
            def maxCheck = 30
            while( !exec.isDone() ) {
                // wait for maximum of 30s
                sleep(1000)
            }

            if ( exec.isDone() ) {
                logger.info( "\tDone for " + pluginName)
                installed = true
            } else {
                logger.error( "\tTimeout error while installing " + pluginName)
            }
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

        // This will trigger an immedate restart since all scripts are stopped
        throw new RestartRequiredException(null)
    }
}