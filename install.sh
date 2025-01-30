#!/usr/bin/env bash

password() {
  local length=12
  cat /dev/urandom | tr -dc A-Za-z0-9~_- | head -c $length && echo
}

echo "Creating new .env file"
cp sample.env .env

read -p "Enter your domain name like: example.com " DOMAIN
sed --in-place "s/{HOSTNAME}/$DOMAIN/g" .env
read -p "Enter your acme email like: test@example.com " ACME_EMAIL
sed --in-place "s/{TRAEFIK_EMAIL}/$ACME_EMAIL/g" .env
read -p "What is your first name " FIRST_NAME
sed --in-place "s/{FIRSTNAME}/$FIRST_NAME/g" .env
read -p "What is your last name " LAST_NAME
sed --in-place "s/{LASTNAME}/$LAST_NAME/g" .env
read -p "What is your blog name " BLOG_NAME
sed --in-place "s/{BLOGNAME}/$BLOG_NAME/g" .env
read -p "What is your Admin username " ADMIN_USERNAME
sed --in-place "s/{ADMINUSERNAME}/$ADMIN_USERNAME/g" .env
read -p "What is your Admin email " ADMIN_EMAIL
sed --in-place "s/{ADMINEMAIL}/$ADMIN_EMAIL/g" .env

echo "Randomizing Passwords"
DBPASS=$(password)
DBADMINPASS=$(password)
TRAEFIKPASS=$(password)
TREFIKHASH=$(echo -n "$TRAEFIKPASS" | sha1sum | awk '{print $1}')
WPADMINPASS=$(password)
sed --in-place "s/{DBPASSWORD}/$DBPASS()/g" .env
sed --in-place "s/{DBADMINPASSWORD}/$DBADMINPASS/g" .env
sed --in-place "s/{TRAEFIKPASSWORD}/$TRAEFIKPASS/g" .env
sed --in-place "s/{TRAEFIKHASH}/$TREFIKHASH/g" .env
sed --in-place "s/{WPADMINPASSWORD}/$WPADMINPASS/g" .env
echo "Your traefik password is $TRAEFIKPASS"
echo "Your admin password is $WPADMINPASS"
echo "Please go change the smtp details in the .env file"

docker network create traefik-network
docker network create wordpress-network



