pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
  name: elk
spec:
  containers:
  - name: dnd
    image: docker:latest
    command: 
    - cat
    tty: true
    volumeMounts: 
    - mountPath: /var/run/docker.sock
      name: docker-sock
  - name: kubectl
    image: bryandollery/terraform-packer-aws-alpine
    command:
    - cat
    tty: true
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock  
      type: Socket
"""
    }
  }
  environment {
    TOKEN=credentials('8b8b0611-4abe-490c-b382-b34889fe39bb')
}
  stages {
      stage("Deploy") {
          steps {
              container('kubectl') {
                  sh '''
                    cd elk/
                    . elk.sh  
                    kubectl --token=$TOKEN -n elk get all
                     
                  '''
              }
          }
      }
  }
}
