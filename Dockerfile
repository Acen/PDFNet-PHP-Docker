FROM php:7.2

MAINTAINER zac@tuft.co.nz

# Install Dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	    wget \
	    swig \
	    cmake \
		make && \
	rm -rf /var/lib/apt/lists/*

# Download Assets
RUN mkdir /root/PDFNet && \
    wget https://github.com/PDFTron/PDFNetWrappers/archive/master.tar.gz -P /root/PDFNet/ && \
    cd /root/PDFNet && \
    tar xzvf master.tar.gz && \
    cd PDFNetWrappers-master/PDFNetC && \
    wget http://www.pdftron.com/downloads/PDFNetC64.tar.gz && \
    tar xzvf PDFNetC64.tar.gz && \
    mv PDFNetC64/Headers/ . && \
    mv PDFNetC64/Lib/ . && \
    cd .. && \
    mkdir build

# Add to Swig Interface file, so `Config` class doesn't clash with Laravel.
RUN cd /root/PDFNet/PDFNetWrappers-master/build && \
    sed -i "/^%rename (IsEqual) operator==;/a %rename (PDFNetConfig) Config;" "../PDFNetPHP/PDFNetPHP.i"


# Build & Install.
RUN cd /root/PDFNet/PDFNetWrappers-master/build && \
    cmake -D BUILD_PDFNetPHP=ON .. && \
    make && \
    make install

RUN cp -r /root/PDFNet/PDFNetWrappers-master/build/lib/ /PDFNetPHP/ && \
    rm -rf /root/PDFNet/
