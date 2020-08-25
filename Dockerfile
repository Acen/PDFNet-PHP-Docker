FROM php:7.2.25

MAINTAINER zac@tuft.co.nz

ENV PDFNETWRAPPER_GIT_SHA1=26ed84c89a842eb2164bad3769993df6e2031ba4 \
    PDFNETC64_FILE_SHA1=b3f965eaaa270f5253a587491581b2986ce76571 \
    PDFNETOCRMODULE_FILE_SHA1=d6e8fc919422be7eaf26668ad9688763e15cd63c \
    PDFNET_VERSION=7.1.0

# Install Dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	    wget \
	    swig \
	    cmake \
		make && \
	rm -rf /var/lib/apt/lists/* && \
	mkdir /root/PDFNet

WORKDIR /root/PDFNet
# Get PDFNetWrappers
RUN wget -nv https://github.com/PDFTron/PDFNetWrappers/archive/$PDFNETWRAPPER_GIT_SHA1.tar.gz && \
    tar xzf $PDFNETWRAPPER_GIT_SHA1.tar.gz && \
    echo "PDFNetWrapper downloaded to $(pwd)."

# Get C Headers/Lib
RUN cd PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/PDFNetC && \
    wget -nv http://www.pdftron.com/downloads/PDFNetC64.tar.gz && \
    echo "$PDFNETC64_FILE_SHA1 PDFNetC64.tar.gz" | sha1sum -c - && \
    tar xzf PDFNetC64.tar.gz && \
    mv PDFNetC64/Headers/ . && \
    mv PDFNetC64/Lib/ . && \
    echo "PDFNetC64 Downloaded. /Headers and /Lib placed in $(pwd)."

# Get OCR Module.
RUN mkdir OCR && \
    cd OCR && \
    wget -nv https://www.pdftron.com/downloads/OCRModuleLinux.tar.gz && \
    echo "$PDFNETOCRMODULE_FILE_SHA1 OCRModuleLinux.tar.gz" | sha1sum -c - && \
    tar xzf OCRModuleLinux.tar.gz && \
    echo "OCRModuleLinux downloaded to $(pwd)." && \
    mkdir build

WORKDIR /root/PDFNet/PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/build

# Add to Swig Interface file, so `Config` class doesn't clash with Laravel.
RUN sed -i "/^%rename (IsEqual) operator==;/a %rename (PDFNetConfig) Config;" "../PDFNetPHP/PDFNetPHP.i"


# Build & Install.
RUN cmake -D BUILD_PDFNetPHP=ON .. && \
    make && \
    make install

RUN cp -r /root/PDFNet/PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/build/lib/ /PDFNetPHP/ && \
    cp /root/PDFNet/PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/PDFNetC/Lib/libPDFNetC.so.$PDFNET_VERSION /PDFNetPHP/libPDFNetC.so && \
    cp /root/PDFNet/OCR/Lib/OCRModule /PDFNetPHP/OCRModule

COPY test_sha1.sh /test_sha1.sh
RUN chmod 777 /test_sha1.sh
