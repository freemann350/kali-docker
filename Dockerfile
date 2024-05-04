FROM kalilinux/kali-rolling:latest
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."

# Install kali packages
ARG KALI_METAPACKAGE=core
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install kali-linux-${KALI_METAPACKAGE}
RUN apt-get -y install kali-tools-top10
RUN apt-get clean

# Install kali desktop
ARG KALI_DESKTOP=xfce
RUN apt-get -y install kali-desktop-${KALI_DESKTOP}
RUN apt-get -y install tightvncserver dbus dbus-x11 novnc net-tools

# Set container user as root
ENV USER root

# Environment variables
ENV VNCEXPOSE 0
ENV VNCPORT 5900
ENV VNCPWD changeme
ENV VNCDISPLAY 1920x1080
ENV VNCDEPTH 16

# Install custom packages
RUN apt-get -y install nano konsole iputils-ping

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD [ "./entrypoint.sh" ]
ENTRYPOINT ["/bin/bash"]
