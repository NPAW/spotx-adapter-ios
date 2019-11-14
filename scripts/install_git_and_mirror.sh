cat ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
apt-get update
apt-get install -y git
mkdir -p ~/.ssh
(umask 077; echo $QA_SSH_KEY | base64 --decode > ~/.ssh/id_rsa)          
git push --all git@github.com:NPAW/spotx-adapter-ios.git  
git push --tags git@github.com:NPAW/spotx-adapter-ios.git