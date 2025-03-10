pipeline {
	agent any
	tools {
		nodejs "nodejs-23-9-0"
	}
	environment {
        NVD_API_KEY = credentials('NVD_Key')
		// MONGO_URI = credentials("MONGO_URI")
		MONGO_URI  = "mongodb://5.tcp.eu.ngrok.io:19988/superData?authSource=admin"
		MONGO_USERNAME = "admin"
		MONGO_PASSWORD = "password"
		// MONGO_USERNAME = credentials("MONGO_USERNAME")
		// MONGO_PASSWORD = credentials("MONGO_PASSWORD")
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
				sh 'echo Colon-Separated - $MONGO_URI'
                sh 'echo Username - $MONGO_USERNAME'
                sh 'echo Password - $MONGO_PASSWORD'
				sh "npm test"
				// NPM Test JUnit Report
				junit allowEmptyResults: true, skipPublishingChecks: true, testResults: 'test-results.xml'
			}
		}
	}	
}
