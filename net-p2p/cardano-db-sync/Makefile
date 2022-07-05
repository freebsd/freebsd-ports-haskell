PORTNAME=       cardano-db-sync
PORTVERSION=    13.0.0
CATEGORIES=     net-p2p
EXTRACT_ONLY+=  input-output-hk-libsodium-${LIBSODIUM_HASH}_GH0${EXTRACT_SUFX} \
                bitcoin-core-secp256k1-${SECP256K1_HASH}_GH0${EXTRACT_SUFX}

MAINTAINER=     arrowd@FreeBSD.org
COMMENT=        Core component of the Cardano decentralized blockchain

LICENSE=        APACHE20

BUILD_DEPENDS=  bash:shells/bash \
                git:devel/git \
                postgresql14-server>0:databases/postgresql14-server \
                postgresql14-client>0:databases/postgresql14-client \
                postgresql14-contrib>0:databases/postgresql14-contrib \
                postgresql-libpqxx>0:databases/postgresql-libpqxx

USES=           autoreconf:build cabal gmake libtool pkgconfig

USE_GITHUB=     yes
GH_ACCOUNT=     input-output-hk bitcoin-core:secp
GH_PROJECT=     ${PORTNAME} libsodium:sodium secp256k1:secp
GH_TAGNAME=     ${PORTVERSION} ${LIBSODIUM_HASH}:sodium ${SECP256K1_HASH}:secp

USE_RC_SUBR=    cardano_db_sync

CARDANO_SYNC_HASH=      67367b5ae317b2915de94dc3be43c29d796d876e
LIBSODIUM_HASH=         66f017f16633f2060db25e17c170c2afa0f2a8a1
# Obtained from https://github.com/input-output-hk/cardano-node/blob/master/.github/workflows/github-page.yml#L21
SECP256K1_HASH=         ac83be33d0956faf6b7f61a60ab524ef7d6a473a
LIBS_PREFIX=            ${WRKDIR}/libs_install

CABAL_PROJECT=          append
EXECUTABLES=            exe:cardano-db-sync exe:cardano-db-tool
SKIP_CABAL_PLIST=       yes
CABAL_ENV=              HOME=${CABAL_HOME} PKG_CONFIG_PATH=${LIBS_PREFIX}${PREFIX}/libdata/pkgconfig/
CABAL_ARGS=             --disable-benchmarks --disable-tests

# setenv http_proxy http://10.10.7.1:3128/
# git config --global http.proxy http://10.10.7.1:3128/

post-patch:
        ${REINPLACE_CMD} -e 's/$$(gitRevFromGit)/"${CARDANO_SYNC_HASH}"/' \
                         -e '/Cardano.Db.RevFromGit/d' \
                         ${WRKSRC}/cardano-db/src/Cardano/Db/Version.hs

pre-build:
        ${RM} -rf ${CABAL_HOME}
        ${MKDIR} ${CABAL_HOME}
        ${SETENV} ${CABAL_ENV} cabal update

do-build:
        cd ${WRKSRC_sodium} && ./autogen.sh
        cd ${WRKSRC_sodium} && ./configure --prefix=${PREFIX} --with-pthreads --disable-shared
        cd ${WRKSRC_sodium} && gmake -j${MAKE_JOBS_NUMBER} && gmake DESTDIR=${LIBS_PREFIX} install
        ${MKDIR} ${LIBS_PREFIX}${PREFIX}/libdata/pkgconfig
        ${MV} ${LIBS_PREFIX}${PREFIX}/lib/pkgconfig/libsodium.pc ${LIBS_PREFIX}${PREFIX}/libdata/pkgconfig/libsodium.pc

        cd ${WRKSRC_secp} && ./autogen.sh
        cd ${WRKSRC_secp} && ./configure --prefix=${PREFIX} --enable-module-schnorrsig --enable-experimental --with-pic --disable-shared
        cd ${WRKSRC_secp} && gmake -j${MAKE_JOBS_NUMBER} && gmake DESTDIR=${LIBS_PREFIX} install
        ${MV} ${LIBS_PREFIX}${PREFIX}/lib/pkgconfig/libsecp256k1.pc ${LIBS_PREFIX}${PREFIX}/libdata/pkgconfig/libsecp256k1.pc

        ${ECHO} "package *" >> ${WRKSRC}/cabal.project.cardano-db-sync
        ${ECHO} "  extra-include-dirs: ${LIBS_PREFIX}${PREFIX}/include" >> ${WRKSRC}/cabal.project.cardano-db-sync
        ${ECHO} "  extra-lib-dirs: ${LIBS_PREFIX}${PREFIX}/lib" >> ${WRKSRC}/cabal.project.cardano-db-sync
        ${MV} ${WRKSRC}/cabal.project.cardano-db-sync ${WRKSRC}/cabal.project
        cd ${WRKSRC} && ${SETENV} ${CABAL_ENV} cabal ${CABAL_ARGS} configure ${EXECUTABLES}
        cd ${WRKSRC} && ${SETENV} ${CABAL_ENV} cabal ${CABAL_ARGS} build ${EXECUTABLES}

do-install:
.for exe in ${EXECUTABLES:S/exe://}
        ${INSTALL_PROGRAM} \
                $$(find ${WRKSRC}/dist-newstyle -name ${exe} -type f -perm +111) \
                ${STAGEDIR}${PREFIX}/bin
.endfor

.include <bsd.port.mk>
