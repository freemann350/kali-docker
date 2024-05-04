#!/bin/bash

# Set password for VNC
mkdir -p /root/.vnc/
echo $VNCPWD | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd
echo "VNC password set successfully"

if [ $VNCEXPOSE = 1 ]
then
  # Expose VNC
  vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH \
    > /var/log/vncserver.log 2>&1
else
  # Localhost VNC only
  vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH -localhost \
      > /var/log/vncserver.log 2>&1
fi
echo "VNC server started"

# Start NoVNC (NO SSL)
/usr/share/novnc/utils/novnc_proxy --listen 8080 --vnc localhost:5900 \
    > /var/log/novnc.log 2>&1 &
echo "NoVNC proxy started"

echo "Launch your web browser and open http://localhost:9020/vnc.html"

# Keep container running
tail -f /dev/null
