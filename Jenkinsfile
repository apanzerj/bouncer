pipeline {
  agent any
  parameters {
    string(name: "PISTACHIO_BUCKET", defaultValue: 'optimizely-pci-pistachio')
    string(name: "PISTACHIO_PATH", defaultValue: 'github-namely')
  }

  stages {
    // stage('rbenv install') {
    //   steps {
    //     sh """
    //     git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
    //     export PATH=\"$HOME/.rbenv/bin:\$PATH\"
    //     eval \"\$(rbenv init -)\"
    //     mkdir -p ~/.rbenv/plugins
    //     cd ~/.rbenv/plugins
    //     git clone git://github.com/sstephenson/ruby-build.git
    //     rbenv install 2.5.0
    //     rbenv rehash
    //     gem i bundle
    //     """
    //   }
    // }
    stage('Prepare') {
      steps {
        sh "PISTACHIO_BUCKET=${params.PISTACHIO_BUCKET} PISTACHIO_PATH=${params.PISTACHIO_PATH} trailmix github sendgrid ad -f env-file > .env"
        sh "bundle install"
      }
    }

    stage('Run') {
      steps {
        sh "bundle exec ruby bouncer.rb"
      }
    }
  }
}
