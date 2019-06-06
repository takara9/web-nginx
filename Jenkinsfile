def label = "web-nginx-${UUID.randomUUID().toString()}"

podTemplate(
  label: label,
  containers: [
    containerTemplate(name: 'dockerd', image: 'docker:dind', ttyEnabled: true, alwaysPullImage: true, privileged: true,
      command: 'dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 --storage-driver=overlay'),
    containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:latest', ttyEnabled: true, alwaysPullImage: true, privileged: true, command: 'cat' )
  ],
  volumes: [
    emptyDirVolume(memory: false, mountPath: '/var/lib/docker'),
    configMapVolume(mountPath: '/kubeconfig', configMapName: 'kubeconfig-iks1')
  ]
) 

{
  node (label) {
    withCredentials([
      usernamePassword(credentialsId: 'docker_id', usernameVariable: 'DOCKER_ID_USR', passwordVariable: 'DOCKER_ID_PSW')
    ]) {
      stage('build') {
        container('dockerd') {
            git url: 'https://github.com/takara9/web-nginx'
	    stage 'setup'
            sh 'docker login --username=$DOCKER_ID_USR --password=$DOCKER_ID_PSW'
            stage 'build'
            sh 'docker build -t maho/web-nginx:$BUILD_NUMBER .'
	    stage 'push'
	    sh 'docker push maho/web-nginx:$BUILD_NUMBER'
            sh 'docker images'
        }
      }
      stage('deploy') {
        container('kubectl') {
            stage 'setup'
	    sh 'kubectl version'
	    sh 'KUBECONFIG=/kubeconfig/kube-config-tok05-iks1.yml kubectl get node'
	    stage 'deploy'
	    sh 'cat kubernetes/deployment.yaml.tmpl |sed s/\'XXXXX\'/$BUILD_NUMBER/ > kubernetes/deployment.yaml'
	    sh 'KUBECONFIG=/kubeconfig/kube-config-tok05-iks1.yml kubectl apply -f kubernetes/deployment.yaml'
	    sh 'KUBECONFIG=/kubeconfig/kube-config-tok05-iks1.yml kubectl apply -f kubernetes/service.yaml'	    	    
            stage 'expose'
	    sh 'KUBECONFIG=/kubeconfig/kube-config-tok05-iks1.yml kubectl apply -f kubernetes/ingress.yaml'
        }
      }
    }
  }
}
