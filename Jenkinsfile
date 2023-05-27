def branch = "cicd"
def repo = "git@github.com:myayangs/fe-dumbmerch.git"
def cred = "appserver"
def dir = "~/fe-dumbmerch"
def server = "yyg@103.13.207.241"
def imagename = "fe-dumbmerch-cicd"
def dockerusername = "myyngstwn"

pipeline {
    agent any
    stages {
        stage('Repository Pull') {
            steps {
                sshagent([cred]) {
                  sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                        cd ${dir}
			            git checkout ${branch}
                        git pull origin ${branch}
                        exit
                        EOF
                    """
                }
            }
        }

        stage('Build Image Docker') {
            steps {
                sshagent([cred]) {
                 sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                        cd ${dir}
                        docker build -t ${imagename}:latest .
                        exit
                        EOF
                    """
                }
            }
        }

        stage('Running Image in Container') {
            steps {
                sshagent([cred]) {
                 sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                        cd ${dir}
                        docker container stop ${imagename}
                        docker container rm ${imagename}
                        docker run -d -p 3000:3000 --name="${imagename}"  ${imagename}:latest
                        docker container stop ${imagename}
                        docker container rm ${imagename}
                        exit
                        EOF
                    """
                }
            }
        }
        
        stage('Push Image Docker') {
            steps {
                sshagent([cred]) {
			     sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
				        docker tag ${imagename}:latest ${dockerusername}/${imagename}:latest
				        docker image push ${dockerusername}/${imagename}:latest
				        docker image rm ${dockerusername}/${imagename}:latest
				        docker image rm ${imagename}:latest
				        exit
                        EOF
			        """
		        }
            }
        }
    }
}
