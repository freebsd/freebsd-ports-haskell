PORTNAME=	cardano-node
PORTVERSION=	1.34.1
CATEGORIES=	net-p2p
EXTRACT_ONLY+=	${GH_ACCOUNT}-libsodium-${LIBSODIUM_HASH}_GH0${EXTRACT_SUFX}

MAINTAINER=	arrowd@FreeBSD.org
COMMENT=	Core component of the Cardano decentralized blockchain

LICENSE=	APACHE20

BUILD_DEPENDS=	bash:shells/bash \
		git:devel/git \
		jq:textproc/jq

CONFLICTS_INSTALL=	libsodium

USES=		autoreconf:build cabal gmake libtool pkgconfig

USE_GITHUB=	yes
GH_ACCOUNT=	input-output-hk
GH_PROJECT=	${PORTNAME} libsodium:sodium
GH_TAGNAME=	${PORTVERSION} ${LIBSODIUM_HASH}:sodium

USE_RC_SUBR=	cardano_node

GHC_VERSION=		8.10.7
LIBSODIUM_HASH=		66f017f16633f2060db25e17c170c2afa0f2a8a1
LIBSODIUM_PREFIX=	${WRKDIR}/libsodium_install

CABAL_PROJECT=		append
SKIP_CABAL_PLIST=	yes
CABAL_ENV=		HOME=${CABAL_HOME} PKG_CONFIG_PATH=${LIBSODIUM_PREFIX}${PREFIX}/libdata/pkgconfig/

# setenv http_proxy http://10.10.7.1:3128/
# git config --global http.proxy http://10.10.7.1:3128/

pre-build:
	${RM} -rf ${CABAL_HOME}
	${MKDIR} ${CABAL_HOME}
	env ${CABAL_ENV} cabal update

do-build:
	cd ${WRKSRC_sodium} && ./autogen.sh
	cd ${WRKSRC_sodium} && ./configure --prefix=${PREFIX} --with-pthreads
	cd ${WRKSRC_sodium} && gmake -j${MAKE_JOBS_NUMBER} && gmake DESTDIR=${LIBSODIUM_PREFIX} install
	${MKDIR} ${LIBSODIUM_PREFIX}${PREFIX}/libdata/pkgconfig
	mv ${LIBSODIUM_PREFIX}${PREFIX}/lib/pkgconfig/libsodium.pc ${LIBSODIUM_PREFIX}${PREFIX}/libdata/pkgconfig/libsodium.pc

	${ECHO} "package *" >> ${WRKSRC}/cabal.project.cardano-node
	${ECHO} "  extra-include-dirs: ${LIBSODIUM_PREFIX}${PREFIX}/include" >> ${WRKSRC}/cabal.project.cardano-node
	${ECHO} "  extra-lib-dirs: ${LIBSODIUM_PREFIX}${PREFIX}/lib" >> ${WRKSRC}/cabal.project.cardano-node
	mv ${WRKSRC}/cabal.project.cardano-node ${WRKSRC}/cabal.project
	cd ${WRKSRC} && env ${CABAL_ENV} cabal configure --with-compiler=ghc-${GHC_VERSION}
	cd ${WRKSRC} && env ${CABAL_ENV} cabal build all

do-install:
	cd ${WRKSRC_sodium} && gmake DESTDIR=${STAGEDIR} install
	cd ${WRKSRC} && ${INSTALL_PROGRAM} `./scripts/bin-path.sh cardano-node` ${STAGEDIR}${PREFIX}/bin
	cd ${WRKSRC} && ${INSTALL_PROGRAM} `./scripts/bin-path.sh cardano-cli` ${STAGEDIR}${PREFIX}/bin

.include <bsd.port.mk>
