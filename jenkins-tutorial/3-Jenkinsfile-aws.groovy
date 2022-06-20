pipeline {
  agent {
    docker {
      image env.AGENT_DOCKER_IMAGE ?: 'ctmnz/jenkins-agent-packer-docker:latest'
      args "--entrypoint='' -v /certs/client:/certs/client"
    }
  }

  environment {
    PACKER_CACHE_DIR = "${env.WORKSPACE_TMP}/.packer.d/packer_cache"
    PACKER_CONFIG_DIR = "${env.WORKSPACE_TMP}/.packer.d"
    PACKER_HOME_DIR = "${env.WORKSPACE_TMP}/.packer.d"
    PACKER_PLUGIN_PATH = "${env.WORKSPACE_TMP}/.packer.d/plugins"
    TMPDIR = "${env.WORKSPACE_TMP}"
    DOCKER_HOST = "tcp://${DOCKER_HOST_IP}:2376"
    AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY}"
    AWS_SECRET_ACCESS_KEY="${AWS_SECRET_KEY}"
    AWS_DEFAULT_REGION="${AWS_REGION}" 
  }

  stages {
    stage('Packer - Build AWS CryptoWare AMI') {
      steps {
        sh """
        #!/bin/sh
        cd jenkins-tutorial
        packer init aws-debian.pkr.hcl
        packer build -force aws-debian.pkr.hcl
        """
      }
    }
    stage('Docker - Verify Docker Image') {
      steps {
        sh """
        #!/bin/sh
        docker images
        """
      }
    }
  }
}
