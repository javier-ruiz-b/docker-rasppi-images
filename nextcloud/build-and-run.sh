sudo docker build . -t nextcloud && sudo docker run -p80:80 -p443:443 -it --rm --name nextcloud nextcloud
