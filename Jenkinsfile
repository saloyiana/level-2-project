
pipeline {
    agent any
    stages {
        stage('firstStage') {
            steps {
                echo "first-stage"
            }
        }
        stage('building jobs') {
            parallel {
                stage('office job') {
                    steps {
                        build(job: "office")
                    }
                }
                stage('role job') {
                    steps {
                        build(job: "role")
                    }
                }
               stage('person job') {
                    steps {
                        build(job: "person")
                    }
                }
               stage('department job') {
                    steps {
                        build(job: "department")
                    }
                } 
               stage('main job') {
                    steps {
                        build(job: "main") 
                    }
                }
            }
        }
    }
}
