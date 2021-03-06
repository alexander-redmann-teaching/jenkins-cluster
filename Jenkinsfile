// explanation could be found here https://akomljen.com/set-up-a-jenkins-ci-cd-pipeline-with-kubernetes/
def label = "worker-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
  containerTemplate(name: 'gradle', image: 'gradle:4.5.1-jdk9', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.8.8', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm:latest', command: 'cat', ttyEnabled: true)
],
volumes: [
  hostPathVolume(mountPath: '/home/gradle/.gradle', hostPath: '/tmp/jenkins/.gradle'),
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
  node(label) {
    def myRepo = checkout scm
    def gitCommit = myRepo.GIT_COMMIT
    def gitBranch = myRepo.GIT_BRANCH
    def shortGitCommit = "${gitCommit[0..10]}"
    //def previousGitCommit = sh(script: "git rev-parse ${gitCommit}~", returnStdout: true)
 
    stage('Test') {
      try {
        container('gradle') {
          sh """
            pwd
            echo "GIT_BRANCH=${gitBranch}"
            echo "GIT_COMMIT=${gitCommit}"
            gradle --version  -g gradle-user-home -s
            gradle -g gradle-user-home -s test
            """
        }
      }
      catch (exc) {
        println "Failed to test - ${currentBuild.fullDisplayName}"
        //throw(exc)
      }
    }
    stage('Build') {
      container('gradle') {
        try {
          sh "gradle -g gradle-user-home build"        
        }
        catch (exc) {
          println "Failed to build - ${exc}"
          //throw(exc)
        }  
      }
    }
    stage('Create Docker images') {
      container('docker') {
        
        try {
        //withCredentials([[$class: 'UsernamePasswordMultiBinding',
          //credentialsId: 'dockerhub',
          //usernameVariable: 'DOCKER_HUB_USER',
          //passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          
            //docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
          sh """
            docker build -t namespace/my-image:${gitCommit} .            
            """
        //}
        
        }
        catch (exc) {
          println "Failed to build docker - ${exc}"
          //throw(exc)
        }    
      }
    }
    stage('Run kubectl') {
      container('kubectl') {
        try {
          sh "kubectl get pods"        
        }
        catch (exc) {
          println "Failed to run docker - ${exc}"
          //throw(exc)
        }    
      }
    }
    stage('Run helm') {
      container('helm') {
        try {
         sh "helm list"
        }
        catch (exc) {
          println "Failed to run helm - ${exc}"
          //throw(exc)
        }   
      }
    }
  }
}
