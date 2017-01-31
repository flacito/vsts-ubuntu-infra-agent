FROM microsoft/vsts-agent:ubuntu-16.04-docker-1.12.1

# Install packages
RUN echo "deb [arch=amd64] http://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list \
 && apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    # Basic utilities
    curl \
    dnsutils \
    ftp \
    iproute2 \
    iputils-ping \
    openssh-client \
    sudo \
    telnet \
    time \
    unzip \
    wget \
    zip \
    # Essential build tools (gcc, make, etc.)
    build-essential \
    # Python
    python \
    python3 \
    # Java and related build tools
    openjdk-8-jdk \
    ant \
    ant-optional \
    ruby \
    golang \
    # .NET Core SDK
    dotnet-dev-1.0.0-rc3-004530 \
 && rm -rf /var/lib/apt/lists/*

# Install maven separately to avoid apt-get errors
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    maven \
 && rm -rf /var/lib/apt/lists/*

# Install gradle separately to avoid apt-get errors
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    gradle \
 && rm -rf /var/lib/apt/lists/*

# Install stable Node.js and related build tools
RUN curl -sL https://git.io/n-install | bash -s -- -ny - \
 && ~/n/bin/n stable \
 && npm install -g bower grunt gulp n \
 && rm -rf ~/n

# Configure environment variables
ENV ANT_HOME=/usr/share/ant \
    bower=/usr/local/bin/bower \
    dotnet=/usr/bin/dotnet \
    GRADLE_HOME=/usr/share/gradle \
    grunt=/usr/local/bin/grunt \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    M2_HOME=/usr/share/maven

# Setup MSbuild alias (remove once we have this natively)
RUN echo "alias msbuild='dotnet msbuild'" >> /etc/bash.bashrc
