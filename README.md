# tmate server in docker

This repo contains a quick way to run a tmate server in docker. Use gnu `make` for interactions.

```
$ make help
clean          Stop container and delete generated content.
help           Print Makefile help.
install-hooks  Install git hooks.
keys           Create tmate server keys.
restart        Restart the running container.
run            Run a local tmate server.
stop           Stop running container.
```

```
$ PORT=6622 make run
./create_keys.sh
Use the generated tmate.conf file to connect to this server:

    tmate -f /home/dademurphy/garbage/docker-tmate/tmate.conf

docker run \
    --name=tmate \
    --rm \
    --detach \
    --mount "type=bind,src=/Users/daniel.hoherd/code/docker-tmate/keys,dst=/keys" \
    --publish 6622:2200 \
    --env SSH_KEYS_PATH=/keys \
    --cap-add SYS_ADMIN \
    tmate/tmate-ssh-server
9e104bd0f4695655321ae43f77b81cd0d489880ccbe48b0b2ed53b38189c565f
```

# Caveats

- Hostnames that are given by tmate are the docker container name, which is not helpful for actually connecting. You will need to replace the hostname with whatever you intend your client to connect to.
