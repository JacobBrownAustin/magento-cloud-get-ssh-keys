FROM php:7.4-cli

RUN apt-get update \
 && apt-get install -y ncat \
 && apt-get install -y openssh-client \
 && rm -rf /var/lib/apt/lists/* \
 && curl -sS https://accounts.magento.cloud/cli/installer | php

EXPOSE 5000

CMD bash -c "source ~/.bashrc \
&&  echo Starting ncat for port forwarding \
&& (ncat -k -l 0.0.0.0 5001 --sh-exec \"ncat localhost 5000\" &) \
&& echo Logging into magento-cloud.  Now is good time to run this. xdg-open http://127.0.0.1:5000 \
&& magento-cloud login \
&&  echo Creating ssh certificate \
&& magento-cloud ssh-cert:load -y \
&&  echo Fixing permissions for certificate \
&& USERID=$(stat -c \"%u\" /root/.magento-cloud/.session/sess-cli-default/ssh/) \
&& GROUPID=$(stat -c \"%g\" /root/.magento-cloud/.session/sess-cli-default/ssh/) \
&& chown -R \$USERID:\$GROUPID /root/.magento-cloud/.session/sess-cli-default/ssh/ \
&& echo Done!"

