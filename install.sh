#!/bin/bash

source ./config/env
WORKDIR=./www

if [ ! -d $WORKDIR ]; then
  mkdir ./www
fi

if [ -z "$(ls -A $WORKDIR)" ]; then

  lando start
  lando xdebug-off
  cd ./www

  echo "Creating magento project"
  lando composer config --global http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
  lando composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=$MAGENTO_VERSION .
  lando composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY

  echo "Set file permissions"
  lando ssh -c "find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +"
  lando ssh -c "find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +"
  lando ssh -c "chown -R :www-data ."
  lando ssh -c "chmod u+x bin/magento"

  echo "Install magento"
  lando ssh -c "bin/magento setup:install --db-host=database --db-name=magento --db-user=magento --db-password=magento --admin-firstname=Admin --admin-lastname=User --admin-email=user@example.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=Europe/Warsaw --use-rewrites=1 --search-engine=elasticsearch7 --elasticsearch-host=$ELASTIC_HOST --elasticsearch-port=9200 --elasticsearch-index-prefix=magento2 --elasticsearch-timeout=15 --backend-frontname=admin"
  lando ssh -c "bin/magento config:set web/secure/base_url https://$PROJECT_URL.lndo.site/"
  lando ssh -c "bin/magento config:set web/unsecure/base_url http://$PROJECT_URL.lndo.site/"
  lando ssh -c "bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth"
  lando ssh -c "bin/magento setup:di:compile"

  echo "Set developer mode"
  lando ssh -c "bin/magento deploy:mode:set developer"
  lando ssh -c "bin/magento cache:disable full_page layout block_html translate"

  echo "Install MAGERUN CLI tools"
  lando composer require n98/magerun2-dist

  if [ "$DEPLOY_SAMPLE_DATA" = true ]; then
    echo "Deploying sample data"
    lando ssh -c "bin/magento sampledata:deploy"
    lando ssh -c "bin/magento setup:upgrade"
    lando ssh -c "bin/magento c:f"
  fi

  lando ssh -c "bin/magento cron:install"
  cd ../
  lando restart
  lando xdebug-off

else
  echo "/www directory is not empty!"
fi
