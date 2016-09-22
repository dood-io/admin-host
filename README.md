# admin-host

### Overview

This repository serves as a base repository for creating an admin host for performing
administrative tasks for your server environment.

This repository is intended to be forked into private repo, where you can store your
private information. This is meant to serve as a common base that applies to all
environments and will not contain any confidential information.

### Usage

* Clone this repo into a private repo
* Add your confidential information to your private repo


### Creating a Private Fork

##### Create a Private Repo

Go to your preferred VCS and create a **private** repository:

* [Bitbucket](https://confluence.atlassian.com/bitbucket/create-a-git-repository-759857290.html)
* [GitHub](https://help.github.com/articles/creating-a-new-repository/)

##### Clone the Repo Locally

Clone the newly-created private repo to your local environment:

```
(~):$ cd <workspace>
(~/workspace):$ git clone <repo_url> private-admin-host
```

##### Fork the Repo

Now, we need to [fork the admin-host repo](https://help.github.com/articles/fork-a-repo).

```
(~/workspace):$ cd private-admin-host

(~/workspace/private-admin-host):$ git remote -v
origin	git@<vcs provider>:<private repo>.git (fetch)
origin	git@<vcs provider>:<private repo>.git (push)

(~/workspace/private-admin-host):$ git remote add upstream https://github.com/dood-io/admin-host.git

(~/workspace/private-admin-host):$ git remote -v
origin	git@<vcs provider>:<private repo>.git (fetch)
origin	git@<vcs provider>:<private repo>.git (push)
upstream	https://github.com/dood-io/admin-host.git (fetch)
upstream	https://github.com/dood-io/admin-host.git (push)

(~/workspace/private-admin-host):$ git fetch upstream
From https://github.com/dood-io/admin-host
 * [new branch]      develop    -> upstream/develop
 * [new branch]      master     -> upstream/master
```


##### Sync the Forked Repo

Now, we need to [sync the forked repo](https://help.github.com/articles/syncing-a-fork/) into your private repo.

```
(~/workspace/private-admin-host):$ git fetch upstream

(~/workspace/private-admin-host):$ git checkout master

(~/workspace/private-admin-host):$ git merge upstream/master

(~/workspace/private-admin-host):$ git push -u origin master
```
