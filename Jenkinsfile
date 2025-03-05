pipeline {
	agent any
	tools {
		nodejs "nodejs-23-9-0"
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
							--prettyPrint''', odcInstallation: 'owasp-dependcheck-10'
					}
				}
			}
		}
	}	
}
