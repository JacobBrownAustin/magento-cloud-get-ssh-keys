# Getting ssh keys for Magento Cloud using magento-cloud command

# Setup

## Create the image

```
docker build -t magento-cloud-get-ssh-keys .
```
## Make the directory that the keys will be stored in

```
mkdir ~/.magento-cloud.ssh/
```

## Configure ssh to use the new keys

add this to your ~/.ssh/config
```
Host *.magento.cloud
  CertificateFile ~/.magento-cloud.ssh/id_rsa-cert.pub
  IdentityFile ~/.magento-cloud.ssh/id_rsa

```

# Use it

## Run the docker image to create or update ssh keys and launch web browser to login to Magento Cloud

```
((sleep 3 ; xdg-open http://127.0.0.1:5000 ) &) ; docker run --mount type=bind,source="$HOME"/.magento-cloud.ssh,target=/root/.magento-cloud/.session/sess-cli-default/ssh/ -p 5000:5001 -ti  magento-cloud-get-ssh-keys
```
