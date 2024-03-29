PORTNAME=	luv
DISTVERSION=	1.44.2-1
CATEGORIES=	devel

MAINTAINER=	adamw@FreeBSD.org
COMMENT=	libuv bindings for lua
WWW=		https://github.com/luvit/luv

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/LICENSE.txt

LIB_DEPENDS=	libuv.so:devel/libuv \
	 	libluajit-5.1.so:lang/luajit-openresty

USES=		cmake
USE_LDCONFIG=	yes
USE_GITHUB=	yes
GH_ACCOUNT=	luvit keplerproject:compat
GH_PROJECT=	luv lua-compat-5.3:compat
GH_TAGNAME=	e245d3a:compat
GH_SUBDIR=	deps/lua-compat-5.3:compat

OPTIONS_DEFINE=	DOCS EXAMPLES

CMAKE_ON=	BUILD_SHARED_LIBS WITH_SHARED_LIBUV
CMAKE_OFF=	BUILD_MODULE
CMAKE_ARGS=	-DLUA_BUILD_TYPE=System \
		-DLUA_COMPAT53_DIR=deps/lua-compat-5.3 \
		-DWITH_LUA_ENGINE=LuaJIT

PLIST_FILES=	lib/libluv.so \
		lib/libluv.so.1 \
		lib/libluv.so.1.44.2 \
		libdata/pkgconfig/libluv.pc \
		include/luv/util.h \
		include/luv/luv.h \
		include/luv/lreq.h \
		include/luv/lhandle.h

PORTDOCS=	docs.md

PORTEXAMPLES=	*

post-install-DOCS-on:
	${MKDIR} ${STAGEDIR}${DOCSDIR}
	${INSTALL_MAN} ${WRKSRC}/docs.md ${STAGEDIR}${DOCSDIR}

post-install-EXAMPLES-on:
	${MKDIR} ${STAGEDIR}${EXAMPLESDIR}
	cd ${WRKSRC}/examples && ${COPYTREE_SHARE} . ${STAGEDIR}${EXAMPLESDIR}

.include <bsd.port.mk>
