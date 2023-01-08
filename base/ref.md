# 接入新节点
- [https://coding.net/help/insight/posts/16124fc8/](https://coding.net/help/insight/posts/16124fc8/)

- `find scripts -type f | xargs sed -i 's/\r//'`

```powershell

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Confirm:$False -Force ; invoke-webrequest https://coding.net/public-files/coding-ci/install/windows/install.ps1?version=2022.05.06-a1999048901b7f3ab9d14df54cda482e44f88d93 -outfile install.ps1; $env:CODING_SERVER='wss://topsa.coding.net'; $env:PACKAGE_URL='https://coding.net'; $env:JENKINS_VERSION='2.293-cci-v2.3'; $env:JENKINS_HOME_VERSION='v51'; $env:PYPI_HOST='https://topsa.coding.net/ci/pypi/simple'; $env:PYPI_EXTRA_INDEX_URL=''; $env:LOG_REPORT='http://worker-beat.coding.net'; .\install.ps1 901bfe27258d57640541dd22729c4b8653896347 false default ;remove-item env:CODING_SERVER
```


## linux script 
```bash

curl -fL 'https://coding.net/public-files/coding-ci/install/linux/install.sh?version=2022.05.06-a1999048901b7f3ab9d14df54cda482e44f88d93' | CODING_SERVER=wss://topsa.coding.net PACKAGE_URL=https://coding.net JENKINS_VERSION=2.293-cci-v2.3 JENKINS_HOME_VERSION=v51 PYPI_HOST=https://topsa.coding.net/ci/pypi/simple PYPI_EXTRA_INDEX_URL= LOG_REPORT=http://worker-beat.coding.net bash -s 901bfe27258d57640541dd22729c4b8653896347 false default
```
