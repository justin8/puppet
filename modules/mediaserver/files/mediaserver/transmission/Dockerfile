FROM linuxserver/transmission

RUN cd / && \
    curl -Lo combustion.zip https://github.com/Secretmapper/combustion/archive/release.zip && \
    unzip combustion.zip && \
    rm combustion.zip

ENV TRANSMISSION_WEB_HOME=/combustion-release
