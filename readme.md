# PDFNet PHP Wrapper
Builds PHP `.so` extension and `.php` library. 



* Built using PHP `7.2.25`
* PDFNetWrapper git SHA1 `26ed84c89a842eb2164bad3769993df6e2031ba4`
* PDFNetC64.tar.gz SHA1 `b3f965eaaa270f5253a587491581b2986ce76571`
* OCRModule SHA1 `d6e8fc919422be7eaf26668ad9688763e15cd63c`
* PDFNet Version `7.1.0`

Output is located in `/PDFNetPHP` folder.

Standard `Config` class has been renamed to `PDFNetConfig` to avoid clashing with Laravel facades.


### Example
```dockerfile
FROM tuft/pdfnet-php:latest as PDFNetPHP


FROM your-normal-image
COPY --from=PDFNetPHP /PDFNetPHP/libPDFNetC.so /usr/lib/libPDFNetC.so
COPY --from=PDFNetPHP /PDFNetPHP/OCRModule /usr/lib/OCRModule
COPY --from=PDFNetPHP /PDFNetPHP/PDFNetPHP.so /usr/lib/php/20170718/PDFNetPHP.so

COPY config/pdfnetphp.ini /etc/php/7.2/mods-available/pdfnetphp.ini
RUN ln -s /etc/php/7.2/mods-available/pdfnetphp.ini /etc/php/7.2/cli/conf.d/10-pdfnetphp.ini && \
    ln -s /etc/php/7.2/mods-available/pdfnetphp.ini /etc/php/7.2/apache2/conf.d/10-pdfnetphp.ini
```

config/pdfnetphp.ini
```ini
; priority=10
extension=PDFNetPHP.so

```

### License
> May not be relevant, due to not actually packaging either source code or binaries. This you'd be running yourself to fetch the source. But yolo, better safe than sorry.

https://github.com/PDFTron/PDFNetWrappers/blob/master/LICENSE.txt
```
Copyright (c) 2019, PDFTron Systems Incorporated. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Any derived software is used for sole purpose of interfacing with PDFTron PDFNet SDK.

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Neither the name of PDFTron Systems Incorporated, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOTLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

```
