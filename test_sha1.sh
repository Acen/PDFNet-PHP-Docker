#!/usr/bin/env bash
shaMatch=true
ocrModuleHash=($(sha1sum /root/PDFNet/OCR/OCRModuleLinux.tar.gz))
if [ "$ocrModuleHash" != "$PDFNETOCRMODULE_FILE_SHA1" ]; then
  shaMatch=false
fi

pdfNetHash=($(sha1sum /root/PDFNet/PDFNetWrappers-$PDFNETWRAPPER_GIT_SHA1/PDFNetC/PDFNetC64.tar.gz))
if [ "$pdfNetHash" != "$PDFNETC64_FILE_SHA1" ]; then
  shaMatch=false
fi

if [ $shaMatch ]; then
  echo "SHA hashes match successfully."
  exit 0
fi
echo "Failed SHA1 Matching"
exit 1
