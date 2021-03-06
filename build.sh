#!/bin/bash
patch -Np1 -i "${SHED_PATCHDIR}/nss-3.36.1-standalone-1.patch" &&
cd nss &&
make -j1 BUILD_OPT=1 \
         NSPR_INCLUDE_DIR=/usr/include/nspr \
         USE_SYSTEM_ZLIB=1 \
         ZLIB_LIBS=-lz \
         NSS_ENABLE_WERROR=0 \
         NSS_USE_SYSTEM_SQLITE=1 \
         $([[ $SHED_NATIVE_TARGET =~ ^aarch64-.* ]] && echo USE_64=1) &&
cd ../dist &&
install -v -m755 -d "${SHED_FAKEROOT}/usr/lib" &&
install -v -m755 Linux*/lib/*.so "${SHED_FAKEROOT}/usr/lib" &&
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} "${SHED_FAKEROOT}/usr/lib" &&
install -v -m755 -d "${SHED_FAKEROOT}/usr/include/nss" &&
cp -v -RL {public,private}/nss/* "${SHED_FAKEROOT}/usr/include/nss" &&
chmod -v 644 "${SHED_FAKEROOT}"/usr/include/nss/* &&
install -v -m755 -d "${SHED_FAKEROOT}/usr/bin" &&
install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} "${SHED_FAKEROOT}/usr/bin" &&
install -v -m755 -d "${SHED_FAKEROOT}/usr/lib/pkgconfig" &&
install -v -m644 Linux*/lib/pkgconfig/nss.pc "${SHED_FAKEROOT}/usr/lib/pkgconfig"
