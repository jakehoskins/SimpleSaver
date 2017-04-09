stage('Bleeding Edge')
{
	node{
		sh "rm -rf SimpleSaver"
		sh "git clone git@github.com:jakehoskins/SimpleSaver.git"
		dir ('SimpleSaver')
		{
			sh "git checkout develop"
			sh "./beta.sh"
		}
	}
}

stage('Prod') {
  input "Do you want to release to the app store?"
  milestone()
  node{
		sh "rm -rf SimpleSaver"
		sh "git clone git@github.com:jakehoskins/SimpleSaver.git"
		dir ('SimpleSaver')
		{
			sh "git checkout develop"
			sh "./prod.sh"
		}

  }
}
