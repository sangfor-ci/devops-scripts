// 使用 centos7 作为 container 进行多个任务的并行测试，都打包到 release目录下，统一上传到 日期编译文件中、

pipeline {
  agent {
    docker {
       //image '10.11.6.26/amd64/centos7:latest'
       //image '10.7.202.199/centos7-node'
       image 'ccr.ccs.tencentyun.com/topsec/centos7-base:amd64'
       label 'master'
        // args  '-v `pwd`:/home/ngos/workspace -w /home/ngos/workspace'
    }
  }

  environment {
      ARTIFACT_REPO_URL = "https://webdav.remote_site.cn/repos/"
      //ARTIFACT_REPO_DIR = "/tmp/release/"
	  //GIT_REPO_URL = "https://10.7.202.199/filestore/ngx-deps/"
	  //GIT_BUILD_REF = "*/master"
	  //CREDENTIALS_ID = "211_gitlab_xx"
	  // RELEASE_SITE_DIR = "https://10.7.202.199/filestore/ngx-deps/"
	  ARTIFACT_REPO_DIR = """${
                             sh(
                                     returnStdout: true,
                                     script: 'echo -n "/workdir/release/$(date +%Y%m%d).${BUILD_ID}"'
                             )
                         }"""
     BUILD_USER_EXTRA = "default"
  }

  options {
	  // parallelsAlwaysFailFast()
      // skipDefaultCheckout()
      timestamps()
      disableConcurrentBuilds()
      // buildDiscarder(logRotator(numToKeepStr: '3'))
  }

  triggers {
    pollSCM('H */4 * * 1-5')
    // cron('H */4 * * 1-5')
  }

  stages {


    stage("分支检出 (CheckOut)") {
      steps {
        echo 'checkout current branch jenkins file'
        checkout([
            $class: 'GitSCM',
            branches: [[name: env.GIT_BUILD_REF]],
            userRemoteConfigs: [[url: env.GIT_REPO_URL, credentialsId: env.CREDENTIALS_ID]]]
        ])
      }
    }

    stage('环境测试') {
      // 开始多个并行任务; 每个并行任务独立构建相关的内容。
      parallel {

        stage('0x01. 编译 nmap') {
          steps {
            script {
              sh 'uname -a'
              sh "sed -i 's/\r//' ./auxil/rhel7_prepare.sh && bash ./auxil/rhel7_prepare.sh"
            }
          }
         // end steps
        }

        stage('0x02. 编译 masscan') {
          steps {
            script {
              sh "echo 1"
              sh "echo 22"
              sh "echo 333"
            }
          }
          // end steps
        }

        stage('0x03. 编译 tcpreplay') {
          steps {
            script {
              sh "/bin/bash ./tcpreplay/build.sh"
            }
          }
          // end steps
        }

        stage('0x04. 编译 pgsql') {
          steps {
            script {
              sh "/bin/bash ./pgsql/build.sh"
            }
          }
          // end steps
        }

        stage('0x05. 编译 mysql') {
          steps {
            script {
              sh "/bin/bash ./mysql/mysql_rebuild.sh"
            }
          }
          // end steps
        }

        stage('0x06. 编译 nginx') {
          steps {
            script {
              sh "/bin/bash ./nginx/modsecurity.sh"
            }
          }
          // end steps
        }

        stage('0x07. 编译 redis') {
          steps {
            script {
              sh "/bin/bash ./redis/build.sh"
            }
          }
          // end steps
        }

        stage('0x08. 编译 curl') {
          steps {
            script {
              sh "/bin/bash ./xc_project/curl/build_gm_curl.sh"
            }
          }
          // end steps
        }

        stage('0x08. 编译 curl') {
            parallel {
              stage('0x`10.1`. 编译 sysbench') {
                  steps {
                    script {
                      sh "/bin/bash ./helper/sysbench/build.sh"
                    }
                  }
              // end steps
              }

              stage('0x`10.2`. 编译铜锁 gmssl') {
                  steps {
                    script {
                      sh "/bin/bash ./helper/gmssl/build.sh"
                    }
                  }
              // end steps
              }

            }
        }

      }
    }

    stage('打包并上传-GitHUB') {
        environment {
            ARTIFACT_REPO_DIR="/workdir/release"
        }

       steps {
         // 推送镜像到远程仓库
         sh "/bin/bash ./tools/007_github_api_tools.sh upload_dir ${ARTIFACT_REPO_DIR}"
         echo "Build Comp OK!"

       }
    }

    stage('构建后的操作') {
      steps {
        // 推送镜像到远程仓库
        //sh 'yum -y install patchelf'
      }
    }


    stage('清理空间 (Clean)') {
      steps {
          cleanWs()
          sh """
          echo "Cleaned Up Workspace For Project，USing Docker So inUsable"
          """
          sh "uname -a"
      }
    }

 }

  post {
        always {
            echo "Topsec BigData Tech Licence v1 For BdTech. IC"
        }
    }

}
