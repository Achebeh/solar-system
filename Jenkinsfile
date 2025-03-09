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
						dependencyCheckPublisher failedTotalCritical: 1, pattern: 'dependency-check-report.xml', stopBuild: true
					}
				}
			}
		}
	}	
}
