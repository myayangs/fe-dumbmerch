def branch = "staging"
def repo = "git@github.com:myayangs/fe-dumbmerch.git"
def cred = "appserver"
def dir = "~/fe-dumbmerch"
def server = "yyg@103.13.207.241"
def imagename = "fe-dumbmerch-staging"
def dockerusername = "myyngstwn"

pipeline {
    agent any
      post{
		    always{
             discordSend description: "**Build:** #${env.BUILD_NUMBER}\n **Status:** ${currentBuild.currentResult}", footer: 'Made by Blade', image: '', link: env.BUILD_URL, result: currentBuild.currentResult , scmWebUrl: '', thumbnail: '', title: env.JOB_NAME, webhookURL: 'https://discord.com/api/webhooks/1111442291287142441/IE758PVExU1NC9UNp7G2bxCMaK3T8IBJk1aaSiMNxbdG_C4y5l_r_VKvqfuXsXSPUNQU' 		
        }
	}
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