# ssh-jumphost

Re-work of t3n/docker-ssh-jump which is an extended Docker image to run an SSH server.
Added support for setting the authorized keys via environment variables.

## Configuration:

### Environment:

- USER - comma separated list of usernames to create, default if not set is `jump`
- AUTH*KEY_0 .. AUTH_KEY_9 - public keys to add to \_authorized_keys*

### Volumes:

A directory containing files with public keys can be mounted under /keys/. All files there will be appended to _authorized_keys_

- publickeys:/keys

## Usage examples:

### With public keys directory:

```sh
docker run --name ssh_server -d -e USER=`whoami` -v ~/.ssh/pubkeys:/keys ghcr.io/zaro/docker-ssh-jump
```

### With public keys from env:

```sh
# using the default user jump
docker run --name ssh_server -d -e AUTH_KEY_0="..." -e AUTH_KEY_1="..." ghcr.io/zaro/docker-ssh-jump
```
