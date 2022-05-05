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

CABAL_PROJECT=		append
SKIP_CABAL_PLIST=	yes

.if !defined(PACKAGE_BUILDING) && !defined(OVERRIDE)
IGNORE=		This port is not supposed to be built outside poudriere jail. It pollutes ${PREFIX}
.endif

CABAL_HOME=	${WRKSRC}/cabal-home

# setenv http_proxy http://10.10.7.1:3128/
# git config --global http.proxy http://10.10.7.1:3128/
pre-build:
	${MKDIR} ${CABAL_HOME}
	env HOME=${CABAL_HOME} cabal update

do-build:
	cd ${WRKSRC_sodium} && ./autogen.sh
	cd ${WRKSRC_sodium} && ./configure --prefix=${PREFIX} --with-pthreads
	cd ${WRKSRC_sodium} && gmake -j${MAKE_JOBS_NUMBER} && gmake install
	mv ${PREFIX}/lib/pkgconfig/libsodium.pc ${PREFIX}/libdata/pkgconfig/libsodium.pc

	mv ${WRKSRC}/cabal.project.cardano-node ${WRKSRC}/cabal.project
	cd ${WRKSRC} && env HOME=${CABAL_HOME} cabal configure --with-compiler=ghc-${GHC_VERSION}
	cd ${WRKSRC} && env HOME=${CABAL_HOME} cabal build all

#	cd /tmp/cardano-node-${PORTVERSION} && tar -f /root/cardano-node-${PORTVERSION}.tar.gz -cJ .

do-install:
	cd ${WRKSRC_sodium} && gmake DESTDIR=${STAGEDIR} install
	cd ${WRKSRC} && cp `./scripts/bin-path.sh cardano-node` ${STAGEDIR}${PREFIX}/bin
	cd ${WRKSRC} && cp `./scripts/bin-path.sh cardano-cli` ${STAGEDIR}${PREFIX}/bin
	cp ${PREFIX}/lib/libsodium.so.23.3.0 ${STAGEDIR}${PREFIX}/lib
	cp ${PREFIX}/lib/libsodium.so.23 ${STAGEDIR}${PREFIX}/lib
	cp ${PREFIX}/lib/libsodium.so ${STAGEDIR}${PREFIX}/lib

.include <bsd.port.mk>
