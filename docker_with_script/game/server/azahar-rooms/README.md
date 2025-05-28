# Runnind a container


### Customize the following command to initialize a container based on Azahar docker image

Customize:

- port/protocoll
- container name
- first volume
- docker image


```
docker run -d -p 51230:51230/udp \
    --name azahar_pkmn_gen6_room1 \
    -v /opt/game/server/azahar-rooms/pkmn_gen6_room1:/opt/azahar \
    -v /opt/game/server/azahar-rooms/all/motd:/opt/motd \
    -v /opt/game/server/azahar-rooms/all/next_maintenance:/opt/next_maintenance \
    --restart always \
    azahar-room_arm:2120.3
```
