pipeline {
  agent any
  environment {
    PATH = "/home/jenkins/.rbenv/bin:/home/jenkins/.rbenv/shims:$PATH"
  }
  stages {
    stage('Prepare') {
      steps {
        sh "trailmix --ssm-context github-namely --ssm-region us-west-2 -f env-file ad gh sendgrid > .env"
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
  post {
    success {
      archiveArtifacts '*.csv'
    }
  }
}
