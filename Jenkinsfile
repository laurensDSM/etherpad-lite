pipeline {
    agent any
    
    stages {
	stage('OWASP Dependency Check') {
            steps {
                    script {
                        def additionalArguments = '''\
                            -o ./
                            -s ./
                            -f ALL
                            --prettyPrint
                        '''

                        dependencyCheck(
                            additionalArguments: additionalArguments,
                            odcInstallation: 'owasp'
                        )
                    }

                    dependencyCheckPublisher(pattern: 'dependency-check-report.xml')
                }
            }

        stage('Build') {
            steps {
                // Voer de buildstappen uit (bijv. installatie van afhankelijkheden, bouwen van Etherpad)
                sh 'docker compose build'
            }
        }
        stage('Trivy Check') {
            steps {
                sh "trivy image --no-progress --exit-code 0 --severity MEDIUM,HIGH,CRITICAL --format template --template '@/usr/local/share/trivy/templates/html.tpl' -o trivy_report.html etherpad-etherpad:latest"
                archiveArtifacts artifacts: 'trivy_report.html', allowEmptyArchive: true
            }
        }

        stage('Deployment') {
            steps {
                // Implementeer Etherpad in de gewenste omgeving (bijv. productie)
                //sh 'echo "Deploying Etherpad..."'
                sh 'docker compose up -d'
               
            }
        }
        stage('Install npm dependencies') {
            steps {
                script {
                    // Navigeer naar de Jenkins-workspace
                    dir("${WORKSPACE}") {
                        // Voer npm install uit
                        sh 'npm init -y'

                        sh 'npm install'
                    }
                }
            }
        }

        stage ('Trufflehog Check') {
            steps {
                sh 'docker pull trufflesecurity/trufflehog:latest'
                sh 'rm trufflehog_results.json || true'
                sh 'rm trufflehog_results.html || true'
                sh 'docker run -v "$WORKSPACE:/pwd" trufflesecurity/trufflehog:latest filesystem /pwd --json 2>&1 | grep -v "unable to read file for MIME type detection: EOF" > trufflehog_results.json'
                sh './convert_json_to_html.sh'
                archiveArtifacts artifacts: 'trufflehog_results.html', allowEmptyArchive: true
            }
        }

    }
    post {
        failure {
            // Voer acties uit bij falen van de pipeline, bijvoorbeeld meldingen of blokkeren van verdere stappen
            sh 'echo "Pipeline failed!"'
        }
        always {  
            publishHTML(
                target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: false,
                    reportDir: '.',
                    reportFiles: 'trufflehog_results.html',
                    reportName: 'Trufflehog Report',
                    reportTitles: '',
                    useWrapperFileDirectly: true
                ]
            )
            publishHTML(
                target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: false,
                    reportDir: '.',
                    reportFiles: 'trivy_report.html',
                    reportName: 'Trivy Report',
                    reportTitles: '',
                    useWrapperFileDirectly: true
                ]
            )
            publishHTML(
                target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: false,
                    reportDir: '.',
                    reportFiles: 'eslint.xml',
                    reportName: 'Eslint Report',
                    reportTitles: '',
                    useWrapperFileDirectly: true
                ]
            )
        }
    }     
}