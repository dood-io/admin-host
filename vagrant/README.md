# vagrant

### Overview

This `vagrant` directory should be used to contain vagrant configuration directories.


=== Preconfigured Configurations

There are preconfigured vagrant configurations in the *`.preconfigured`* directory.
In order to use one of the preconfigured configurations and "claim" it, you can just
symlink it at the top-level -- e.g.:

```
(admin-host/vagrant) $ ln -snf .preconfigured/trusty64-01 wordpress
```

These preconfigured configurations have:

* 1024MB memory
* 1 core
* Class B IP address
* Each OS family in separate subnets:
    * *`trusty32`*: `172.16.1.*`
    * *`trusty64`*: `172.16.2.*`
  

=== Custom Configurations

If the preconfigured configurations do not suit your needs, you should create a custom
configuration:

```
(admin-host/vagrant) $ mkdir custom-vagrant && cd custom-vagrant
(admin-host/vagrant/custom-vagrant) $ vagrant init ubuntu/trusty64
(admin-host/vagrant/custom-vagrant) $ git add Vagrantfile
```


Custom configurations should be in a [separate address space](https://en.wikipedia.org/wiki/Private_network)
from the preconfigured configurations:

* *Class A*: `10.0.0.0`
* *Class C*: `192.168.0.0`
