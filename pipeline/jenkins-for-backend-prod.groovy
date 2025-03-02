appUser = "shoeshop"
registryUrl = 'moda.id.vn'
folderDeploy = "/datas/${appUser}/"
imageName = "${registryUrl}/ecommerce/backend-prod"

loginRegistryScript = "docker login ${registryUrl} -u admin -p Harbor12345"
permissionsScript = "chown -R ${appUser}:${appUser} ${folderDeploy}"
downScript = "docker compose down"
removeOldImageScript = "docker rmi -f ${imageName}:latest && docker image prune -a -f"
pullImageScript = "docker pull ${imageName}:latest"
runScript = 'docker compose up -d'
startScript = "sudo su ${appUser} -c '${loginRegistryScript} &&\n" +
    "    ${permissionsScript} &&\n" +
    "    cd ${folderDeploy} &&\n" +
    "    ${downScript} &&\n" +
    "    ${removeOldImageScript} &&\n" +
    "    ${pullImageScript} &&\n" +
    "    ${runScript}'"

stopScript = "sudo su ${appUser} -c 'cd ${folderDeploy} &&\n" +
    "    ${downScript} &&\n" +
    "    ${removeOldImageScript}'\n"

restartScript = "sudo su ${appUser} -c '${permissionsScript} &&\n" +
    "    cd ${folderDeploy} &&\n" +
    "    ${downScript} &&\n" +
    "    ${runScript}'"

void startProcess() {
    stage('start') {
        sh(script: """ ${startScript} """, label: "start docker container")
    }
}

void stopProcess() {
    stage('stop') {
        if (sh(returnStdout: true, script: 'docker ps -q').trim() == '') {
            echo 'No running containers to stop'
            return
        }
        sh(script: """ ${stopScript} """, label: 'stop docker container')
    }
}

void restartProcess() {
    stage('restart') {
        sh(script: """ ${restartScript} """, label: 'restart docker container')
    }
}

node(params.server) {
    currentBuild.displayName = "${params.action}"
    switch (params.action) {
        case 'start':
            startProcess()
            break
        case 'stop':
            stopProcess()
            break
        case 'restart':
            restartProcess()
            break
        default:
            error("This action doesn't exist. Please check again.") 
    }
}
