# PDFNet PHP Wrapper
Builds PHP `.so` extension and `.php` library. 



* Built using PHP `7.2.25`
* PDFNetWrapper git SHA1 `f649422bec6142acef3aefead83759d969b84d4f`
* PDFNetC64.tar.gz sha1 `ff4ce82712836dcdea320c64ae006866c3ff0651`


Output is located in `/PDFNetPHP` folder.


### Example
```
FROM tuft/pdfnet-php:latest as PDFNetPHP


FROM your-normal-image
COPY --from=PDFNetPHP /PDFNetPHP /blah
```
