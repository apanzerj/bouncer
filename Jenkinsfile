pipeline {
  agent any
  environment {
    PATH = "/home/jenkins/.rbenv/bin:/home/jenkins/.rbenv/shims:$PATH"
  }
  parameters {
    string(name: "PISTACHIO_BUCKET", defaultValue: 'optimizely-pci-pistachio')
    string(name: "PISTACHIO_PATH", defaultValue: 'github-namely')
  }

  stages {
    stage('Prepare') {
      steps {
        sh "PISTACHIO_BUCKET=${params.PISTACHIO_BUCKET} PISTACHIO_PATH=${params.PISTACHIO_PATH} trailmix github sendgrid ad -f env-file > .env"
        sh '''
          bundle install
        '''
      }
    }

    stage('Run') {
      steps {
        sh '''
          bundle exec ruby bouncer.rb
        '''
      }
    }
  }
}
