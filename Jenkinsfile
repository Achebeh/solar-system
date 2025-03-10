pipeline {
	agent any
	tools {
		nodejs "nodejs-23-9-0"
	}
	environment {
        NVD_API_KEY = credentials('NVD_Key')
		MONGO_URI = "mongodb://admin:password@5.tcp.eu.ngrok.io:19988/secretData?authSource=admin"
    }
	stages{
		stage("Install NPM dependencies"){
			steps{
				sh "npm install --no-audit" 
			}
		}
		stage("Dependencies Check"){
			parallel{
				stage("NPM Audit`"){
					steps{
						sh "npm audit --audit-level=critical"
					}
				}

				stage("OWASP Dependency Check Vulnerabilities"){
					steps{
						dependencyCheck additionalArguments: ''' 
							-o './'
							-s  './'
							-f 'ALL' 
							--nvdApiKey $NVD_API_KEY
							--prettyPrint''', odcInstallation: 'owasp-dependcheck-12'

						// OWASP Dependency Check Vulnerabilities
						dependencyCheckPublisher failedTotalCritical: 1, pattern: 'dependency-check-report.xml', stopBuild: true

						// Publish OWASP Dependency Check HTML Report
						publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, icon: '', keepAll: true, reportDir: '.', reportFiles: 'dependency-check-jenkins.html', reportName: 'OWASP HTML Report', reportTitles: '', useWrapperFileDirectly: true])

						// Publish OWASP Dependency Check JUnit Report
						junit allowEmptyResults: true, keepProperties: true, keepTestNames: true, testResults: 'dependency-check-junit.xml'
					}
				}
			}
		}
		stage("Unit Testing"){
			steps{
				withCredentials([usernamePassword(credentialsId: 'mongo-credential', passwordVariable: 'MONGO_PASSWORD', usernameVariable: 'MONGO_USERNAME')]) {
					
					sh "npm test"
				}
				// Publish OWASP Dependency Check JUnit Report
						junit allowEmptyResults: true, keepProperties: true, keepTestNames: true, testResults: 'test-results.xml'
			}
		}
	}	
}
