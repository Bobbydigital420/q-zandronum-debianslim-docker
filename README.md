Q-Zandronum v1.4.20

Arguments for Q-Zandronum can be appended to the end of the docker run command. If you are running Unraid the appended arguments go under "
Post Arguments:" under advanced view of the container settings in the WebUI. <br>

The config file for Q-Zandronum is located in /home/zandronum/.config/zandronum <br>
The server is running on the default 10666 port in the container. 

Example


docker run --name q-zandronum \
	-p 10666:10666/udp \
	--volume /path/to/wads:/home/zandronum/.config/zandronum \ 
	bobbydigital420/q-zandronum \
        +set SV_WeaponStay true +set SV_NoWeaponSpawn true +set SV_ShareKeys true -iwad DOOM2.WAD
  
