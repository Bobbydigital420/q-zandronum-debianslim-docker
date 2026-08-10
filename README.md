Q-Zandronum v1.4.22 (amd64/arm64)

Arguments for Q-Zandronum can be appended to the end of the docker run command. If you are running Unraid the appended arguments can be added using the EXTRA_ARGS env variable  <br>

The config file for Q-Zandronum is located in /home/zandronum/.config/zandronum <br>
The server is running on the default 10666 port in the container. 

Example

### Example Usage

```bash
docker run --name q-zandronum \
  -p 10666:10666/udp \
  --volume /path/to/wads:/home/zandronum/.config/zandronum \
  bobbydigital420/q-zandronum-debianslim:latest \
  +set SV_WeaponStay true +set SV_NoWeaponSpawn true +set SV_ShareKeys true -iwad DOOM2.WAD
```


