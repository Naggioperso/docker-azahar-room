# Docker container for Azahar room hosting

## Disclaimer

This rository is in no way affiliated with the the azahar-emulator. If you're looking for the emulator check: https://github.com/azahar-emu/azahar

## How it works

Clone the repository or download the zip.
You can choose to build a docker image that you will use to host a room in two way:

- **Use the cotents of `docker_with_room_exe`**: low effort to start end maintain. Just build the image and run the container. Some things will not persist when removing the container and some customizations will need you sto redeploy the containers
- **Use the contents of `docker_with_script`**: requires to customize the template scripts and map some volumes in the container. To customize the settings of the rooms it's enough to edit some of the files and restart the container. By default, it save the logs to persistent sorage.

Note that the azahar-room executable will run as root inside the container. This is not a best practice and it will be changed in the near future.

---
#### Room hosting with Docker image built with `docker_with_room_exe`

1. Build the Docker image
2. Start the container to host a room

   Example for a public room 
   ```
   docker run -d -p 5000:5000/udp --name your-container-name your-docker-image-name \
       --room-name "Room name" \
       --preferred-app "Name of the preferred game" \
       --preferred-app-id "ID of the preferred game" \
       --port 5000 \
       --max_members 24
       --token "Random user token" \
       --web-api-url "API server"
   ```

   Example for a private room
   ```
     docker run -d -p 5000:5000/udp --name your-container-name your-docker-image-name \
       --room-name "Room name" \
       --preferred-app "Name of the preferred game" \
       --preferred-app-id "ID of the preferred game" \
       --port 5000 \
       --max_members 24
   ```

### Room hosting with Docker image built with `docker_with_script`

*** To make sure that everythings work, keep "_name-of-the-container_" consistent in all configurations ***

1. Build the Docker image
2. Qopy the content of the `game` folder in `docker_with_script` inside `/opt`
3. Change the working directory to `/opt/game/server/azahar-rooms`
   ```
   cd /opt/game/server/azahar-rooms
   ````
4. Create a copy of the files in the template folder
   ```
   cp -r template name-of-the-container # Change it according to your preferences
   ```
5. Edit the `run.sh` in the folder `name-of-the-container/exe/` that you just created. Follow the directions in the script
6. Change the directory and create a copy of the script to spawn a container
   ```
   cd /opt/game/server/azahar-rooms/docker_init
   cp template name-of-the-container
   ```
7. If you want to save the docker run command, rdit the file you just created with the proper values. Follow the directions in the file.
8. If you followed the step above, run the script you just edited or else tun the docker run command manually.
