appUser = 'shoeshop'
registryUrl = 'moda.id.vn'
folderDeploy = "/datas/${appUser}/run"
folderBackup = "/datas/${appUser}/backups"
folderMain = "/datas/${appUser}"
gitLink = 'http://gitlab.moda.com/shoeshop/shoeshop.git'
imageName = "${registryUrl}/ecommerce/backend-staging"

loginRegistryScript = "docker login ${registryUrl} -u admin -p Harbor12345"
permissionsScript = "chown -R ${appUser}:${appUser} ${folderDeploy}"
runScript = 'docker compose up -d'
downScript = 'docker compose down'
pullImageScript = "docker pull ${imageName}:latest"
removeOldImageScript = "docker rmi -f ${imageName}:latest && docker image prune -a -f"

startScript = "sudo su ${appUser} -c '${loginRegistryScript} &&\n" +
    "    cd ${folderDeploy} &&\n" +
    "    ${permissionsScript} &&\n" +
    "    ${downScript} &&\n" +
    "    ${removeOldImageScript} &&\n" +
    "    ${pullImageScript} &&\n" +
    "    ${runScript}'\n"

stopScript = "sudo su ${appUser} -c 'cd ${folderDeploy} &&\n" +
    "    ${downScript} &&\n" +
    "    ${removeOldImageScript}'\n"

String now = new Date().format('ssmmHH_ddMMyyyy')
backupScript = "sudo su ${appUser} -c 'docker save ${imageName}:latest -o ${folderBackup}/backup_image_${now}.tar'"

upcodeScript = "sudo su ${appUser} -c '${loginRegistryScript} &&\n" +
    "    docker build -t ${imageName}:${params.hash} . &&\n" +
    "    docker push ${imageName}:${params.hash} &&\n" +
    "    docker tag ${imageName}:${params.hash} ${imageName}:latest &&\n" +
    "    docker push ${imageName}:latest &&\n" +
    "    docker rmi ${imageName}:${params.hash} &&\n" +
    "    docker rmi ${imageName}:latest'"

startAfterRollbackScript = "cd ${folderDeploy} &&\n" +
    "    ${permissionsScript} &&\n" +
    "    ${runScript}\n"

rollbackScript = "sudo su ${appUser} -c 'docker load -i ${folderBackup}/${params.old_version} &&\n" +
    "    ${startAfterRollbackScript}'\n"

void startProcess() {
    stage('start') {
        sh(script: """ ${startScript} """, label: 'start docker container')
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

void backupProcess() {
    stage('backup') {
        if (sh(returnStdout: true, script: "docker images -q ${imageName}:latest").trim() != '') {
            sh(script: """ ${backupScript} """, label: 'backup docker image')
        }
    }
}

void rollbackProcess() {
    stage('rollback') {
        String fileName = params.old_version

        if (fileName == '' || !fileExists("${folderBackup}/${fileName}")) {
            error('Backup file does not exist')
        }
        sh(script: """ ${rollbackScript} """, label: 'rollback docker image')
    }
}

// pull -> build and push
void upcodeProcess() {
    stage('pull') {
        if (params.hash == '') {
            error('require hashing for code update.')
        }
        checkout([$class: 'GitSCM', branches: [[ name: params.hash ]],
            userRemoteConfigs: [[ credentialsId: 'jenkins-gitlab-user-account', url: gitLink ]]])
    }

    stage('buildandpush') {
        sh(script: """ ${upcodeScript} """, label: 'build and push docker image')
    }
}

node(params.server) {
    currentBuild.displayName = params.action
    switch (params.action) {
        case 'upcode':
            currentBuild.displayName = 'server ' + params.server + ' - code update ' + params.hash
            backupProcess()
            stopProcess()
            upcodeProcess()
            startProcess()
            break
        case 'start':
            startProcess()
            break
        case 'stop':
            stopProcess()
            break
        case 'rollback':
            stopProcess()
            rollbackProcess()
            break
        default:
            error('Invalid action parameter: ' + params.action)
    }
}
