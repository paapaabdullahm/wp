# WP-CLI
WP-CLi is the official command line tool for WordPress. This image variant does not contain WordPress itself, but instead contains.

**Current Tag: cli-2.4.0-php7.4**

## Usage
For WP-CLI to interact with a WordPress install, it needs access to the on-disk files of the WordPress install, and access to the corresponding database.

Two of the many ways of accomplishing this are outlined below. Also, to simplify wp-cli execution, the entire `docker run` command is wrapped inside a shell script.

### Via An Environment file

Create a script with your favourite editor
```sh
$ vim wp.sh
```

Add the following docker run command to the file
```sh
#!/bin/sh

# A wrapper script for invoking wp-cli with docker
# Put this script in $PATH as wp

# specify which image version to use
VERSION=v2.4.0;

# initialize tty flag with a null value
TTY_FLAG=``

# add tty flag if execution context is a tty
if [ -t 1 ]; then TTY_FLAG="-t"; fi

# invoke wp-cli with networking context via docker run
exec docker run --rm -i ${TTY_FLAG} \
     --env-file ./.env \
     --volume "$(pwd)":/etc/nginx/html \
     --workdir /etc/nginx/html \
     "pam79/wp:${VERSION}" wp "$@";
```

Install wp-cli script globally
```sh
$ sudo install -m 0775 wp.sh /usr/local/bin/wp
```

> Use this method if your wp-config.php file uses an environment file like `.env` or something similar.

Here is a truncated example of a .env file with the parts relevant to wp-cli:

$ cat .env
```sh
...
DB_NAME=wordpress
DB_USER=wordpress
DB_PASSWORD=secret
DB_HOST=192.168.1.252:3306
...
```

Here is a truncated example of wp-config.php file with the parts relevant to wp-cli:

$ cat wp-config.php
```sh
...
define( 'DB_NAME', getenv('DB_NAME') );
define( 'DB_USER', getenv('DB_USER') );
define( 'DB_PASSWORD', getenv('DB_PASSWORD') );
define( 'DB_HOST', getenv('DB_HOST') );
...
```

### Via Networking Context

Create a script with your favourite editor
```sh
$ vim wp.sh
```

Add the following docker run command to the file
```sh
#!/bin/sh

# A wrapper script for invoking wp-cli with docker
# Put this script in $PATH as wp

# specify which image version to use
VERSION=v2.4.0;

# initialize tty flag with a null value
TTY_FLAG=``

# add tty flag if execution context is a tty
if [ -t 1 ]; then TTY_FLAG="-t"; fi

# invoke wp-cli with networking context via docker run
exec docker run --rm -i ${TTY_FLAG} \
     --network container:some-wordpress \
     --volume "$(pwd)":/etc/nginx/html \
     --workdir /etc/nginx/html \
     "pam79/wp:${VERSION}" wp "$@";
```

Install wp-cli script globally
```sh
$ sudo install -m 0775 wp.sh /usr/local/bin/wp
```

### Execute commands with installed script
> We will do this from your WordPress project root, and with redis-cache plugin as an example.

Install plugin
```sh
$ wp plugin install redis-cache
```

Activate plugin
```sh
$ wp plugin activate redis-cache
```

Show the redis object cache status and (when possible) client.
```sh
$ wp redis status
```

To enable the redis object cache
```sh
$ wp redis enable
```

To disables the plugin. Default behavior is to delete the object
```sh
$ wp redis disable
```

To update the redis object cache drop-in
```sh
$ wp redis update-dropin
```

For more info on wp-cli, visit their [official website](https://wp-cli.org/).
