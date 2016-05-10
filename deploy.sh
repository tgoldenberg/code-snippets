## Steps to deploy a Meteor app on a VM (digital ocean or Azure)

**1. Login to vm with ssh** - e.g. `ssh root@IP_ADDRESS`

**2. Add users** - [instructions on creating users on Ubuntu 14.04 and granting sudo privileges](https://www.digitalocean.com/community/tutorials/how-to-add-and-delete-users-on-an-ubuntu-14-04-vps)
 
type `adduser USERNAME` 
 
type `visudo`
 
edit file by adding `newuser ALL=(ALL:ALL) ALL` under `root ALL=(ALL:ALL) ALL`
 
save file and exit

**3. Download Meteor with curl** - type `curl https://install.meteor.com/ | sh` - this will install Meteor and the Meteor cli. Test it out with `meteor --version` or `meteor --help`

**4. Install Node v. 10.04 ** - type the following commands to install NodeJS and the appropriate Ubuntu package for Node

 `curl -sL https://deb.nodesource.com/setup_0.10 | sudo -E bash -`

 `sudo apt-get install -y build-essential nodejs`

 **Note:** Meteor 1.3 currently only supports older versions of Node. Although NodeJS is currently stable at v6.0, Meteor has not yet added support for newer versions. However, this is in the [Meteor roadmap](https://trello.com/b/hjBDflxp/meteor-roadmap)

**5. Add the forever package** - [Forever](https://github.com/foreverjs/forever) is an npm package that runs background processes or daemons. We will use it to run our Meteor / NodeJS app.

 type `npm install -g forever`

**6. Install Git and clone the appropriate repository** - We use `apt-get install` to install packages. Read [more](https://help.ubuntu.com/12.04/serverguide/apt-get.html) about installing packages on Ubuntu.

 type `sudo apt-get install git`
 type `git clone YOUR_REPO_NAME`

**7. Check to make sure the app runs locally** 

 `cd` into the repo directory and type `npm install` to install dependencies

 then run `PORT=3000 meteor run` and see that it runs

**8. Install Nginx for passing proxy from port 80 to port 8080** - [Explanation of networking ports](https://en.wikipedia.org/wiki/Port_(computer_networking))

 The following is a simplified instruction from the official [nginx documentation](http://nginx.org/en/linux_packages.html#stable)

 First you will need to download the nginx `signing key` from the link just above. It should look something like this:

```
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (FreeBSD)

mQENBE5OMmIBCAD+FPYKGriGGf7NqwKfWC83cBV01gabgVWQmZbMcFzeW+hMsgxH
W6iimD0RsfZ9oEbfJCPG0CRSZ7ppq5pKamYs2+EJ8Q2ysOFHHwpGrA2C8zyNAs4I
QxnZZIbETgcSwFtDun0XiqPwPZgyuXVm9PAbLZRbfBzm8wR/3SWygqZBBLdQk5TE
fDR+Eny/M1RVR4xClECONF9UBB2ejFdI1LD45APbP2hsN/piFByU1t7yK2gpFyRt
97WzGHn9MV5/TL7AmRPM4pcr3JacmtCnxXeCZ8nLqedoSuHFuhwyDnlAbu8I16O5
XRrfzhrHRJFM1JnIiGmzZi6zBvH0ItfyX6ttABEBAAG0KW5naW54IHNpZ25pbmcg
a2V5IDxzaWduaW5nLWtleUBuZ2lueC5jb20+iQE+BBMBAgAoBQJOTjJiAhsDBQkJ
ZgGABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCr9b2Ce9m/YpvjB/98uV4t
94d0oEh5XlqEZzVMrcTgPQ3BZt05N5xVuYaglv7OQtdlErMXmRWaFZEqDaMHdniC
sF63jWMd29vC4xpzIfmsLK3ce9oYo4t9o4WWqBUdf0Ff1LMz1dfLG2HDtKPfYg3C
8NESud09zuP5NohaE8Qzj/4p6rWDiRpuZ++4fnL3Dt3N6jXILwr/TM/Ma7jvaXGP
DO3kzm4dNKp5b5bn2nT2QWLPnEKxvOg5Zoej8l9+KFsUnXoWoYCkMQ2QTpZQFNwF
xwJGoAz8K3PwVPUrIL6b1lsiNovDgcgP0eDgzvwLynWKBPkRRjtgmWLoeaS9FAZV
ccXJMmANXJFuCf26iQEcBBABAgAGBQJOTkelAAoJEKZP1bF62zmo79oH/1XDb29S
YtWp+MTJTPFEwlWRiyRuDXy3wBd/BpwBRIWfWzMs1gnCjNjk0EVBVGa2grvy9Jtx
JKMd6l/PWXVucSt+U/+GO8rBkw14SdhqxaS2l14v6gyMeUrSbY3XfToGfwHC4sa/
Thn8X4jFaQ2XN5dAIzJGU1s5JA0tjEzUwCnmrKmyMlXZaoQVrmORGjCuH0I0aAFk
RS0UtnB9HPpxhGVbs24xXZQnZDNbUQeulFxS4uP3OLDBAeCHl+v4t/uotIad8v6J
SO93vc1evIje6lguE81HHmJn9noxPItvOvSMb2yPsE8mH4cJHRTFNSEhPW6ghmlf
Wa9ZwiVX5igxcvaIRgQQEQIABgUCTk5b0gAKCRDs8OkLLBcgg1G+AKCnacLb/+W6
cflirUIExgZdUJqoogCeNPVwXiHEIVqithAM1pdY/gcaQZmIRgQQEQIABgUCTk5f
YQAKCRCpN2E5pSTFPnNWAJ9gUozyiS+9jf2rJvqmJSeWuCgVRwCcCUFhXRCpQO2Y
Va3l3WuB+rgKjsQ=
=A015
-----END PGP PUBLIC KEY BLOCK-----

```

 Once you download that to your machine, using a text editor, copy its contents and create the file `nginx_signing.key` on the vm. Copy the contents to the file and save.

 Next add the signing key to the system - type `sudo apt-key add nginx_signing.key` - you should see a response `OK` after this.

 Next you should find what the `codename` of the vm is - it is `trusty` for Ubuntu 14.04. For a list of codenames, visit [here](http://nginx.org/en/linux_packages.html#distributions)
 
 Using the codename, open up the file `/etc/apt/sources.list` and append these 2 lines to the bottom with the proper codename

```
deb http://nginx.org/packages/ubuntu/ codename nginx
deb-src http://nginx.org/packages/ubuntu/ codename nginx

```

Finally, you can install the nginx package -

```
apt-get update
apt-get install nginx
```

**9. Configure Nginx to act as a proxy to the Meteor app** - [instructions](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-meteor-js-application-on-ubuntu-14-04-with-nginx)

 Nginx acts as a protection to our vm, managing the transfer of data between clients and our app. We can enable it to gzip the contents (speeding up loading time) and proxy requests to our Meteor app on port 8080

 The instructions above will make it seem as if there are the directories `sites-available` and `sites-enabled` in `/etc/nginx`. Newer versions of nginx do not come with these, so we have to create them ourselves.

 type `cd /etc/nginx` and then `mkdir sites-available sites-enabled`

 Next, create a file `app` and add the nginx configuration - `touch sites-available/app`

```
# this section is needed to proxy web-socket connections
map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
}
# HTTP
server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;
        
        server_name http://40.84.26.137;
        
        location = /favicon.ico {
          root /home/will/portal/programs/web.browser/app;
          access_log off;
        }
        
        location ~* "^/[a-z0-9]{40}\.(css|js)$" {
          gzip_static on;
          root /home/will/portal/programs/web.browser;
          access_log off;
        }
        
        location ~ "^/packages" {
          root /home/will/portal/programs/web.browser;
          access_log off;
        }

        # pass requests to Meteor
        location / {
                proxy_pass http://127.0.0.1:8080;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade; # allow websockets
                proxy_set_header Connection $connection_upgrade;
                proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
                proxy_set_header Host $host;
        }
} 
```

Next, create a symlink between the `app` file and the `sites-enabled` folder

`sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app`

And add `sites-enabled` to the `nginx.conf` - add `include /etc/nginx/sites-enabled/*;` to bottom of config file

**10. Build the Meteor app** - [link to build script](https://github.com/agolo/finance_portal/blob/master/build_app.sh)

**11. Start nginx** - type `sudo nginx -t` to check if there are any errors, and then if everything is okay, type `sudo nginx -s reload`. You can alternatively type `sudo service nginx restart`.

 

# build meteor app into js bundle
cd ~/repo
meteor update --release 1.3.1
npm install
rm -rf ~/bundle
meteor build --directory ~

# initialize server modules
cd ~/bundle/programs/server
npm install

# shift previous build to backup and run app with forever.js
rm -rf ~/backup
mv ~/portal ~/backup
mv ~/bundle ~/portal
mkdir ~/logs

export PORT=8080
cd ~/portal
forever start -a -l ~/logs/forever.logs -o ~/logs/portal.out -e ~/logs/portal.err main.js

# nginx config - https://www.digitalocean.com/community/tutorials/how-to-deploy-a-meteor-js-application-on-ubuntu-14-04-with-nginx




