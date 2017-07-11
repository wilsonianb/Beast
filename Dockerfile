FROM ubuntu:latest

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y software-properties-common build-essential
RUN apt-get install -y python-software-properties wget libbz2-dev
RUN apt-get install -y g++ gcc libstdc++6
RUN apt-get install -y build-essential
RUN apt-get install -y python-dev
RUN apt-get install -y libssl-dev libffi-dev
#RUN apt-get install -y subversion automake autotools-dev libc6-dbg
RUN apt-get install -y nodejs binutils-gold

# Install Boost
RUN wget -O boost_1_60_0.tar.gz http://sourceforge.net/projects/boost/files/boost/1.60.0/boost_1_60_0.tar.gz/download
RUN tar xzvf boost_1_60_0.tar.gz
RUN cd boost_1_60_0 && ./bootstrap.sh --prefix=/usr/local 
RUN cd boost_1_60_0 && ./b2 install
ENV BOOST_ROOT=/boost_1_60_0

# Install cmake
#RUN mkdir cmake
#RUN CMAKE_URL="http://www.cmake.org/files/v3.5/cmake-3.5.2-Linux-x86_64.tar.gz" wget --no-check-certificate -O - ${CMAKE_URL} | tar --strip-components=1 -xz -C cmake

#ENV BUILD_SYSTEM bjam
RUN apt-get install -y gdb
ENV VARIANT debug

CMD cd /opt/Beast && $BOOST_ROOT/bjam toolset=gcc \
               variant=$VARIANT \
               address-model=64 \
               -j 4 &&  \
for x in bin/**/$VARIANT/**/*-tests; do $x; done

# Build the Docker image once:
# docker build -t beast-docker-local .

# Build Beast by mounting your local directory:
# docker run --rm -v /home/bwilson/Beast:/opt/Beast beast-docker-local