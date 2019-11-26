FROM php:7.2.25

MAINTAINER zac@tuft.co.nz

ENV PDFNETWRAPPER_GIT_SHA1=f649422bec6142acef3aefead83759d969b84d4f
ENV PDFNETC64_FILE_SHA1=ff4ce82712836dcdea320c64ae006866c3ff0651

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
    wget https://github.com/PDFTron/PDFNetWrappers/archive/$PDFNETWRAPPER_GIT_SHA1.tar.gz -P /root/PDFNet/ && \
    cd /root/PDFNet && \
    tar xzvf $PDFNETWRAPPER_GIT_SHA1.tar.gz && \
    cd PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/PDFNetC && \
    wget http://www.pdftron.com/downloads/PDFNetC64.tar.gz && \
    echo "$PDFNETC64_FILE_SHA1 PDFNetC64.tar.gz" | sha1sum -c - && \
    tar xzvf PDFNetC64.tar.gz && \
    mv PDFNetC64/Headers/ . && \
    mv PDFNetC64/Lib/ . && \
    cd .. && \
    mkdir build

# Add to Swig Interface file, so `Config` class doesn't clash with Laravel.
RUN cd /root/PDFNet/PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/build && \
    sed -i "/^%rename (IsEqual) operator==;/a %rename (PDFNetConfig) Config;" "../PDFNetPHP/PDFNetPHP.i"


# Build & Install.
RUN cd /root/PDFNet/PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/build && \
    cmake -D BUILD_PDFNetPHP=ON .. && \
    make && \
    make install

RUN cp -r /root/PDFNet/PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/build/lib/ /PDFNetPHP/ && \
    rm -rf /root/PDFNet/
