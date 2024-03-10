# Local developement environment for Magento 2 based on Lando and WSL2 (Windows 10)

## Requirements

* [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* [Debian](https://apps.microsoft.com/detail/9msvkqc78pk6) or [Ubuntu](https://www.microsoft.com/pl-pl/p/ubuntu/9nblggh4msv6)
* [Lando](https://docs.lando.dev/)

## :point_right: Setup Lando - step by step
Here you will find the **[article](https://www.liip.ch/en/blog/setup-drupal-and-lando-with-wsl2-on-windows)** on which this repo is based:

### 1. Install WSL 2 on Windows 10
Follow the **[official documentation](https://docs.microsoft.com/en-us/windows/wsl/install-win10)** to install and enable WSL 2.

### 2. Install Linux (Ubuntu or Debian) from the Microsoft Store

Then run it and create a **Non-Root User** (eg. 'jan'):

```
sudo adduser jan
sudo usermod -aG sudo jan
su -  jan
```

Set as default user on Linux start:

``
sudo nano /etc/wsl.conf
``

Create (if not exist) or edit this file:

```
[user]
default=jan
```

And save it.

### 3. Install Docker Desktop .exe on Windows
**https://docs.docker.com/desktop/install/windows-install/**

### 4. Install Lando inside your Linux distro (Ubuntu or Debian)
``
sudo apt install wget
``

Get url versions from **[github.com/lando/lando/releases](https://github.com/lando/lando/releases)**:

``
wget https://github.com/lando/lando/releases/download/v3.20.8/lando-x64-v3.20.8.deb
``

``
sudo dpkg --ignore-depends=docker-ce --install lando-x64-v3.20.8.deb
``

#### After installing lando this way, you may need to edit the ``/var/lib/dpkg/status`` file:

``
sudo nano /var/lib/dpkg/status
``

Search (**ctrl+w**) for **Lando** and remove from dependencies: ``docker-ce``

then save: **ctrl+o**

and exit: **ctrl+x**

### 5. Go to your Magento project and start Lando

```
cd ..
cd projects/magento-2.4.6/lando
lando start
```


## :point_right: Magento 2.4.6 installation

Write your public and private access keys from Magento Marketplace into *config/env* file and state if you need Magento Sample Data by setting DEPLOY_SAMPLE_DATA to true or false.

To install clean Magento 2.4.6 instance run *install.sh* script

```bash
$ bash ./install.sh
```

Magento 2 will be installed in the *www* directory.
After installation store will be available at *https://magento246.lndo.site* and admin panel at *https://magento246.lndo.site/admin* with user:</br>
name: admin</br>
password: admin123</br>

PhpMyAdmin will be available at *http://phpmyadmin.lndo.site*</br>
user: magento</br>
password: magento</br>

For Magento 2 console commands use:
```bash
$ lando bin/magento <command>
```

for example:
```bash
$ lando bin/magento cache:flush
```

## :point_right: Commands

* Start / build lando

```bash
$ lando start
```

* Stop lando

```bash
$ lando stop
```

* Rebuild lando app

```bash
$ lando rebuild
```

* Destroy app (containers, databse, NOT FILES!)

```bash
$ lando destroy
```

* Import database (supports .sql and sql.gz files)

```bash
$ lando db-import path/to/file.sql
```

* Export database

```bash
$ lando db-export path/to/file.sql
```

* Connect to container's shell

```bash
$ lando ssh
```

* Run command in container's shell (you have to be in docroot directory)

```bash
$ lando ssh -c <command>
```

* Enable Xdebug

```bash
$ lando xdebug-on
```

* Disable Xdebug

```bash
$ lando xdebug-off
```

* Node command

```bash
lando node <command>
```

* NPM command

```bash
lando npm <command>
```

* Grunt command

```bash
lando grunt <command>
```

* Gulp command

```bash
lando gulp <command>
```
