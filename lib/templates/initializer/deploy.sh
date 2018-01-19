#!/bin/sh

# Usage: sh deploy.sh tag_name

SSH_USERNAME="USER"
SSH_HOST="HOSTNAME"
GIT_REPOSITORY="REPOSITORY_NAME"
GIT_URL="REPOSITORY_URL"

# Params
TAG=$1
ENV=$2

# Colors helpers
C_YELLOW='\033[1;33m'
C_GREEN='\033[0;32m'
C_NC='\033[0m'

# Check tag presence
if [ -z "$1" ]; then

  echo "Tag not defined! :("
  exit 0

fi

# Start deploy process
if [ $ENV = "remote" ]; then

  echo "\n${C_GREEN}Starting deploy script on the remote machine! :)${C_NC} \n"

  echo "${C_YELLOW}Cloning new version of the application and prepare database...${C_NC}"
  cd ..
  echo "${C_YELLOW}Please, insert the authentication with the repository${C_NC}"
  git clone --branch $TAG $GIT_URL
  cd $GIT_REPOSITORY
  bundle install
  rails db:migrate
  rails assets:precompile
  echo "\n${C_GREEN}Repository clone completed! :)${C_NC}\n"

  echo "${C_YELLOW}Linking new version as current version...${C_NC}"
  cd ..
  rm -rf $TAG
  mv $GIT_REPOSITORY $TAG
  rm -rf ./current
  ln -s -r ./$TAG ./current
  echo "\n${C_GREEN}New version link completed! :)${C_NC}\n"

  echo "${C_YELLOW}Restarting the system...${C_NC}"
  echo "${C_YELLOW}Please, insert the production machine password...${C_NC}"
  # sudo service redis restart
  # sudo service sidekiq restart
  sudo service nginx restart
  echo "\n${C_GREEN}System restart completed! :)${C_NC}\n"

else

  SCRIPT="
  source .bash_profile &&
  cd versions/current &&
  sh ./deploy.sh $TAG remote
  "

  echo "${C_YELLOW}Please, insert the production machine password...${C_NC}"
  ssh -t $SSH_USERNAME@$SSH_HOST $SCRIPT

fi
