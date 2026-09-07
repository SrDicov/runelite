FROM ubuntu:26.04 AS source

ADD --checksum=sha256:418aba881d2f5fd5c717c84429c13ded6cee0c3f70412c95957b85fd85d75536 https://github.com/runelite/launcher/releases/download/2.8.0/RuneLite.AppImage /tmp/source

RUN chmod 0755 /tmp/source && \
    cd /tmp && \
    ./source --appimage-extract >/dev/null && \
    mv /tmp/squashfs-root /out

FROM ghcr.io/containerpak/gtk3:main

RUN apt-get update && apt-get install -y --no-install-recommends libxtst6 && rm -rf /var/lib/apt/lists/*

COPY --from=source /out /opt/runelite
COPY icon.png /usr/share/icons/hicolor/128x128/apps/runelite.png

RUN mkdir -p /usr/share/applications && \
    printf '#!/bin/sh\nexec /opt/runelite/AppRun "$@"\n' > /usr/bin/runelite && \
    chmod 0755 /usr/bin/runelite && \
    printf '[Desktop Entry]\nName=RuneLite\nExec=runelite\nIcon=runelite\nType=Application\nCategories=Game;\n' > /usr/share/applications/net.runelite.RuneLite.desktop && \
    cpak-clean-junk
