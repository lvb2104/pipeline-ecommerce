import jenkins.model.*
import hudson.FilePath

backupsPath = '/datas/shoeshop/backups/'
def node = Jenkins.getInstance().getNode(server)
def remoteDir = new FilePath(node.getChannel(), "${backupsPath}") // determine directory

def files = remoteDir.list()
def fileName = files.collect { it.name }

if (action == 'rollback') {
    return fileName
}
