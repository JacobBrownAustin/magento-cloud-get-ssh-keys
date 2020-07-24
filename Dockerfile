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
&& echo \"N\nN\nN\n\" | script -e -f -c 'magento-cloud  login' \
&&  echo Copying certificate files to bind mount \
&& cp -f /root/.magento-cloud/.session/sess-cli-default/ssh/* /bind/ \
&&  echo Fixing permissions for certificate \
&& USERID=$(stat -c \"%u\" /bind/) \
&& GROUPID=$(stat -c \"%g\" /bind/) \
&& chown -R \$USERID:\$GROUPID /bind/ \
&& echo Done!"

