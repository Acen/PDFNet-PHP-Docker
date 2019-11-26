#PDFNet PHP Wrapper

Built using `PHP 7.2.25`.

Output is located in `/PDFNetPHP` folder.


### Example
```
FROM tuft/pdfnet-php:latest as PDFNetPHP


FROM your-normal-image
COPY --from=PDFNetPHP /PDFNetPHP /blah
```
