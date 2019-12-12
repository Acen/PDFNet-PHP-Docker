FROM php:7.2.25

MAINTAINER zac@tuft.co.nz

ENV PDFNETWRAPPER_GIT_SHA1=f649422bec6142acef3aefead83759d969b84d4f \
    PDFNETC64_FILE_SHA1=ff4ce82712836dcdea320c64ae006866c3ff0651 \
    PDFNETOCRMODULE_FILE_SHA1=f7f051e4152a026937f120be19fae7656b885bdc

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
    rm -f OCRModuleLinux.tar.gz && \
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
    cp /root/PDFNet/PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/PDFNetC/Lib/libPDFNetC.so.7.0.1 /PDFNetPHP/libPDFNetC.so
