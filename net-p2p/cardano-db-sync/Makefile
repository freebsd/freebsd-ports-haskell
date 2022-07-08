PORTNAME=	cardano-db-sync
PORTVERSION=	13.0.2
CATEGORIES=	net-p2p
EXTRACT_ONLY+=	input-output-hk-libsodium-${LIBSODIUM_HASH}_GH0${EXTRACT_SUFX} \
		bitcoin-core-secp256k1-${SECP256K1_HASH}_GH0${EXTRACT_SUFX}

MAINTAINER=	arrowd@FreeBSD.org
COMMENT=	PostgreSQL-driven Cardano blockchain data tool
		
LICENSE=	APACHE20

BUILD_DEPENDS=	bash:shells/bash \
		git:devel/git \
		ghc-8.10.7:lang/ghc810

RUN_DEPENDS=	cardano-node:net-p2p/cardano-node

WANT_PGSQL=	server

USES=		autoreconf:build cabal gmake libtool pkgconfig pgsql:14

USE_GITHUB=	yes
GH_ACCOUNT=	input-output-hk bitcoin-core:secp
GH_PROJECT=	${PORTNAME} libsodium:sodium secp256k1:secp
GH_TAGNAME=	${PORTVERSION} ${LIBSODIUM_HASH}:sodium ${SECP256K1_HASH}:secp

USE_RC_SUBR=	cardano_db_sync

CARDANO_DB_SYNC_HASH=	8733b71af3ada773755c5cb08d9c061eda11fb96
LIBSODIUM_HASH=		66f017f16633f2060db25e17c170c2afa0f2a8a1
# Obtained from https://github.com/input-output-hk/cardano-node/blob/master/.github/workflows/github-page.yml#L21
SECP256K1_HASH=		ac83be33d0956faf6b7f61a60ab524ef7d6a473a
LIBS_PREFIX=		${WRKDIR}/libs_install

CABAL_PROJECT=		append
EXECUTABLES=		cardano-db-sync cardano-db-tool
CABAL_ENV=		HOME=${CABAL_HOME} PKG_CONFIG_PATH=${LIBS_PREFIX}${PREFIX}/libdata/pkgconfig/
CABAL_ARGS=		--disable-benchmarks --disable-tests ${CABAL_WITH_ARGS}

# setenv http_proxy http://10.10.7.1:3128/
# git config --global http.proxy http://10.10.7.1:3128/

post-patch:
	${REINPLACE_CMD} -e 's/$$(gitRevFromGit)/"${CARDANO_DB_SYNC_HASH}"/' \
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
	cd ${WRKSRC} && ${SETENV} ${CABAL_ENV} cabal ${CABAL_ARGS} configure ${EXECUTABLES:S/^/exe:&/}
	cd ${WRKSRC} && ${SETENV} ${CABAL_ENV} cabal ${CABAL_ARGS} build ${EXECUTABLES:S/^/exe:&/}

post-install:
	${MV} ${WRKSRC}/scripts/postgresql-setup.sh ${WRKSRC}/scripts/cardano-db-sync-pgsql-setup.sh
	${INSTALL_SCRIPT} ${WRKSRC}/scripts/cardano-db-sync-pgsql-setup.sh ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${DATADIR}/schema
	cd ${WRKSRC}/schema && ${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}/schema

.include <bsd.port.mk>
