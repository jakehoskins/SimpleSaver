node {
	stage 'Bleeding Edge'
		sh "sudo gem install bundler"
		sh "git clone git@github.com:jakehoskins/SimpleSaver.git"
		sh "cd SimpleSaver && git checkout develop"
		sh "bundle exec fastlane beta"
	stage 'Prod'
		sh "sudo gem install bundler"
		sh "git clone git@github.com:jakehoskins/SimpleSaver.git"
 		sh "cd SimpleSaver && git checkout develop"
		sh 'bundle exec fastlane release'
}
