# FORKED REPO

Made the Kali VNC container be able to be run over docker-compose, removed noVNC SSL (websockify had errors) & added kali-tools-top10 as default package.

Build first:

```
docker build -t custom-kali .
```

(Make sure the command is run on the same location as the Dockerfile)


## Kali Linux Docker Container with XFCE Desktop over VNC / noVNC

Did you ever wanted to start a fully-fledged Kali Linux Docker container with a full desktop experience? If so, then this Docker image suits your needs: it provides quick access to all Kali Linux tools via CLI and even a Kali Desktop of your choice – directly from within the Docker container. Therefore, it uses the `tightvncserver` to provide a VNC connection to the container and `novnc` for simple VNC access with your browser.

**IMPORTANT:** This image is for testing purposes only. Do not run it on any production systems or for any productive purposes. Feel free to modify it as you like – build instructions are given below.

### 1) Pull

First, pull the image:

```
docker pull iphoneintosh/kali-docker:latest
```

You can also pull images with preconfigured metapackages: `iphoneintosh/kali-docker:default`, `iphoneintosh/kali-docker:large`, or `iphoneintosh/kali-docker:top10`.

### 2) Run

Second, start a new container from the previously pulled image. This opens a new shell on your console as well as a Kali Desktop which you can access in your browser on `https://localhost:8080/vnc.html`.

```
docker run --rm -it -p 9020:8080 -p 9021:5900 iphoneintosh/kali-docker:latest
```

The default configuration is set as follows. Feel free to change this as required.

- `-e VNCEXPOSE=0`
  - By default, the VNC server runs on `localhost` within the container only and is not exposed.
  - Use `-e VNCEXPOSE=1` to expose the VNC server and use a VNC client of your choice to connect to `localhost:9021` with the default password `changeme`.
  - The default port mapping for the VNC server is configured with the `-p 9021:5900` parameter.
- `-e VNCPORT=5900`
  - By default, the VNC server runs on port 5900 within the container.
  - Note: If you change this port, you also need to change the port mapping with the `-p 9021:5900` parameter.
- `-e VNCPWD=changeme`
  - Change the default password of the VNC server.
- `-e VNCDISPLAY=1920x1080`
  - Change the default display resolution of the VNC connection.
- `-e VNCDEPTH=16`
  - Change the default display depth of the VNC connection. Possible values are 8, 16, 24, and 32. Higher values mean better quality but more bandwidth requirements.
- `-e NOVNCPORT=8080`
  - By default, the noVNC server runs on port 8080 within the container.
  - Note: If you change this port, you also need to change the port mapping with the `-p 9020:8080` parameter.
- `-v /your/path/to/cert.pem:/etc/ssl/certs/novnc_cert.pem -v /your/path/to/key.pem:/etc/ssl/certs/novnc_key.pem`
  - By default, the container creates a new self-signed certificate for the noVNC connection at creation time.
  - You can optionally mount your self-signed certificate and key to the container.
  - Use `openssl req -new -x509 -days 365 -nodes -out cert.pem -keyout key.pem` to create a new certificate and key.

### Customization

You can also build a custom image, i.e., if you want to use another Kali Desktop. If so, you can simply pass the Kali Desktop of your choice (i.e., `mate`, `gnome`, ...) as build argument. By default, the XFCE Desktop is configured. You may also edit the `Dockerfile` or `entrypoint.sh` to install custom packages. Also, you can specify different Kali Linux metapackages, i.e., `core`, `default`, `light`, `large`, `everything`, or `top10`. See [https://www.kali.org/news/major-metapackage-makeover/](https://www.kali.org/news/major-metapackage-makeover/) for more details and metapackages.

```
git clone https://github.com/iphoneintosh/kali-docker
cd kali-docker
docker build -t myKali --build-arg KALI_DESKTOP=xfce KALI_METAPACKAGE=large .
docker run --rm -it -p 9020:8080 -p 9021:5900 myKali
```
