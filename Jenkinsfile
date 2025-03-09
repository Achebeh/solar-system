pipeline {
	agent any
	tools {
		nodejs "nodejs-23-9-0"
	}
	environment {
        NVD_API_KEY = credentials('NVD_Key') 
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
	}	
}
