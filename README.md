[![Stories in Ready](https://badge.waffle.io/strator-dev/docker-seafile.png?label=ready&title=Ready)](https://waffle.io/strator-dev/docker-seafile)
[![](https://images.microbadger.com/badges/image/stratordev/seafile.svg)](http://microbadger.com/images/stratordev/seafile "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/stratordev/seafile.svg)](http://microbadger.com/images/stratordev/seafile "Get your own version badge on microbadger.com")

## Seafile Docker image

* github reference project : https://github.com/strator-dev/docker-seafile/
* docker hub referece image : https://hub.docker.com/r/stratordev/seafile/

### Concept

The goal of this image : to create a seafile docker image that can be used without the need to run configurations scripts manually or to tweek configurations files. Most of configuration values can be passed to the first docker run command with configuration variables.

### Easy usage
Choose a data path on your server path.

```bash
sudo mkdir -p /this/will/be/your/data/path
```

```bash
sudo docker \
  run \
  -d \
  -e "SEAFILE_VERSION=5.1.4" \
  -e "SEAFILE_ADMIN_EMAIL=root@root.com" \
  -e "SEAFILE_ADMIN_PASSWORD=Rw5Knb3d91" \
  -e "SEAFILE_HOST=this.ismyhost.com" \
  -e "SEAFILE_PORT=8080" \
  -v "/this/will/be/your/data/path:/opt/seafile" \
  -p 0.0.0.0:8080:8080 \
  --name="seafile" \
  stratordev/seafile
```

And that's it.

The first time, the data path will be filled with everything that needs to be done to have a working seafile server with an admin whose email adress is `root@root.com` and whose passord is `Rw5Knb3d91`.

### Configuration

* **SEAFILE_VERSION** : The seafile server version you want to use. If not specified 5.1.4 is used.
* **SEAFILE_ADMIN_EMAIL** : The admin email (that is the login on seafile server). There is a default value, but I won't document it to make sure you won't use it.
* **SEAFILE_ADMIN_PASSWORD** : The admin password. There is a default value, but I won't document it to make sure you won't use it.
* **SEAFILE_HOST** : The host as seen from internet (or from the users). If you use a complex system of vhosts and reverse proxies in front of that image, this is the hostname configured in you vhost configuration that may be different than the one where you run your docker image.
* **SEAFILE_PORT** : The port as seen from internet (or from the users). If you use a complex system of vhosts and reverse proxies in front of that image, this is the port configured in you vhost configuration that my be different than the one you bind on your docker command. Default value is empty which will be considered as defaut port (80 for http, 443 for https, see **SEAFILE_USE_HTTPS** for https)
* **SEAFILE_USE_HTTPS** : That image only provide http as output, but you may use it through nginx/apache reverse proxy and provide https encryption through that layer. If you do so, define that variable to "**1**".
* **SEAFILE_LDAP_URL** : The ldap url if you're using a ldap server to identify accounts. (if set an not empty, an ldap section will be created in the configuration files, and a ldap server will be used. If you don't know what a ldap server is, don't specify that variable)
* **SEAFILE_LDAP_USER_DN** : The ldap user dn configuration value (see seafile manual for details)
* **SEAFILE_LDAP_BASE** : The ldap base configuration value (see seafile manual for details)
* **SEAFILE_LDAP_PASSWORD** : The ldap password configuration value (see seafile manual for details)
* **SEAFILE_LDAP_LOGIN_ATTR** : The ldap login attr configuration value (see seafile manual for details)

### Init + classic run usage

The usage presented in the "Easy usage" section need to provide configuration values on each run, while it's only needed on the first run. If you're bothered by that you can do :

```
sudo docker \
  run \
  -it \
  --rm=true \
  -e "SEAFILE_VERSION=5.1.4" \
  -e "SEAFILE_ADMIN_EMAIL=root@root.com" \
  -e "SEAFILE_ADMIN_PASSWORD=Rw5Knb3d91" \
  -e "SEAFILE_HOST=this.ismyhost.com" \
  -e "SEAFILE_PORT=8080" \
  -v "/this/will/be/your/data/path:/opt/seafile" \
  --name="seafile-init" \
  stratordev/seafile
  /bin/bash /init
```
It will create everything needed interactively. When the command ends, everything is ready.

And then, you can use for each further starts :
```
sudo docker \
  run \
  -d \
  -v "/this/will/be/your/data/path:/opt/seafile" \
  -p 0.0.0.0:8080:8080 \
  --name="seafile" \
  stratordev/seafile
```

### Using crane as docker manager

If you're using [**crane**](https://github.com/michaelsauter/crane) as a docker manager tool, here is a [`crane.yaml`](doc/crane.yaml) that match the previous example (from the *Init + classic run usage* section)

```yaml
containers:
    seafile-init:
        image: "stratordev/seafile"
        run:
            tty: true
            interactive: true
            rm: true
            volume:
                - "/opt/dockerstore/seafile:/opt/seafile"
            env:
                - "SEAFILE_ADMIN_EMAIL=root@root.com"
                - "SEAFILE_ADMIN_PASSWORD=Rw5Knb3d91"
                - "SEAFILE_HOST=this.ismyhost.com"
                - "SEAFILE_PORT=28080"
            cmd: "/bin/bash /init"
    seafile:
        image: "stratordev/seafile"
        run:
            detach: true
            publish:
                - "28080:8080"
            volume:
                - "/opt/dockerstore/seafile:/opt/seafile"
```

You then just have to type the first time the command `crane run seafile-init` :

```sh
$ crane run seafile-init
[... lot of stuff ...]

----------------------------------------
Successfully created seafile admin
----------------------------------------

$ 
```

And then, each time you want to start/restart the server `crane run seafile` :

```sh
$ crane run seafile
Running container seafile ...
b07b11d881fb265a0d1922a74355d81b428517514c10ee084cfbbeeeffc39b4b
$ 
```

And that's it... Your seafile server is up and running.

### Related projects

* [docker-seafile](https://github.com/strator-dev/docker-seafile/) : A docker image for seafile server
* [docker-seafile-client](https://github.com/strator-dev/docker-seafile-client/) : A docker image for seafile client (interface less)
* [seafile](https://www.seafile.com/) : The seafile project main page
* [docker](http://docker.com/) : The docker project



