FROM ghcr.io/containerpak/gtk:main

ADD --checksum=sha256:418aba881d2f5fd5c717c84429c13ded6cee0c3f70412c95957b85fd85d75536 https://github.com/runelite/launcher/releases/download/2.8.0/RuneLite.AppImage /tmp/source
COPY icon.png /usr/share/icons/hicolor/128x128/apps/runelite.png

RUN apt-get update && \
    apt-get install -y --no-install-recommends fuse3 libgl1 && \
    mkdir -p /opt/runelite && install -m 0755 /tmp/source /opt/runelite/RuneLite.AppImage && printf '#!/bin/sh\nexec /opt/runelite/RuneLite.AppImage --appimage-extract-and-run "$@"\n' > /usr/bin/runelite && chmod 0755 /usr/bin/runelite && printf '[Desktop Entry]\nName=RuneLite\nExec=runelite\nIcon=runelite\nType=Application\nCategories=Game;\n' > /usr/share/applications/net.runelite.RuneLite.desktop && \
    cpak-clean-junk
