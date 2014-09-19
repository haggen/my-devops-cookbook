# My DevOps cookbook

> Rails application server setup, maintenance and deploy guide.

## About

This is a **work in progress**.

This document along with all files within its directory comprise a guide, reference sheet
and automation scripts to setup, deploy and maintain Rails applications.

### Disclaimer:

- Everything here was gathered from the internet.
- I don't provide support to any of it.
- I can't be held responsible for any harm caused by these scripts or misuse of its information.

### Word of caution:

- Customize the configuration variables in `config.sh` to suit your needs.
- Take a moment to read all the scripts and make sure it comply with your expectations.
- Don't run ANY of the scripts unattended, they may require interaction at times and/or get errors.
- These scripts weren NOT tested outside the software stack mentioned below.

### Reference:

You participated in writing or publishing any of the links below ? Thank you, you're awesome. ;)

- https://github.com/h5bp/server-configs-nginx
- http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers
- http://robmclarty.com/blog/how-to-setup-a-production-server-for-rails-4
- http://robmclarty.com/blog/how-to-deploy-a-rails-4-app-with-git-and-capistrano
- https://www.digitalocean.com/community/tutorials/how-to-setup-ruby-on-rails-with-postgres
- https://www.digitalocean.com/community/tutorials/how-to-secure-postgresql-on-an-ubuntu-vps
- https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-14-04

### Collaboration

If you want to talk about this project, suggest improvements or raise concerns please do so;
open an issue, send pull requests or simply reach me through arthur (at) corenzan (dot) com.

## Stack

As of this time, the software I use is:

- [Ubuntu Server 14.0](http://www.ubuntu.com/download/server)
- [Ruby 2.1](http://www.ruby-lang.org)
- [Rails 4.1](http://guides.rubyonrails.org)
- [Passenger 4+](https://www.phusionpassenger.com/documentation/Users%20guide%20Nginx.html)
- [Nginx 1+](http://nginx.org)
- [PostgreSQL 9+](http://www.postgresql.org)
- [Redis 2+](http://redis.io)
- [Foreman](https://github.com/ddollar/foreman) (for daemonization)
- *shell (to automate)
- [Mandrill](https://mandrillapp.com/) (for email)
- [Amazon S3](http://aws.amazon.com/s3) (for storage)
- Any DNS service

## Setup checklist

First things first, you just installed the OS then what ?

✔ `root` password was changed ?
✔ SSH is configured correctly ?
✔ Required ports are allowed in the firewall ?
✔ Required directories were created with proper permisions ?
✔ Required software was installed ?
✔ ...

All the items above are covered upon running `$ bash setup.sh`.

## Deploy checklist

✔ Code was commited and merged successfully ?
✔ Migration's been ran successfully ?
✔ Assets' been pre-compiled successfully ?
✔ ...

## Scripts

- config.sh
- setup.sh
- safety.sh
- database.sh
- application.sh

## License

See LICENSE