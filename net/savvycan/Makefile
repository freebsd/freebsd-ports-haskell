PORTNAME=	savvycan
PORTVERSION=	1.0.245
PORTREVISION=	1
PORTEPOCH=	1
CATEGORIES=	net

MAINTAINER=	leres@FreeBSD.org
COMMENT=	CAN bus reverse engineering and capture tool
WWW=		https://www.savvycan.com/

LICENSE=	MIT

BUILD_DEPENDS=	${PYTHON_PKGNAMEPREFIX}sphinx>=0,1:textproc/py-sphinx@${PY_FLAVOR}

USES=		compiler:c++11-lang gmake python:build,3.6+ qmake qt:5
USE_QT=		buildtools:build core gui help printsupport serialbus \
		serialport websockets-qml widgets

USE_GITHUB=	yes
GH_TUPLE=	collin80:SavvyCAN:${DISTVERSIONPREFIX}${PORTVERSION}
NO_MTREE=	yes
PLIST_FILES=	bin/savvycan \
		man/man1/savvycan.1.gz

PORTSCOUT=	skipv:continuous

OPTIONS_DEFINE+=	DOCS EXAMPLES

PORTDOCS=	*
PORTEXAMPLES=	*

.include <bsd.port.options.mk>

post-build:
	cd ${WRKSRC}/docs && ${GMAKE} man
.if ${PORT_OPTIONS:MDOCS}
	cd ${WRKSRC}/docs && ${GMAKE} html
.endif

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/bin
	${INSTALL_PROGRAM} ${WRKSRC}/SavvyCAN ${STAGEDIR}${PREFIX}/bin/savvycan
	${MKDIR} ${STAGEDIR}${MANPREFIX}/man/man1
	${INSTALL_MAN} ${WRKSRC}/docs/build/man/savvycan.1 \
	    ${STAGEDIR}${MANPREFIX}/man/man1
.if ${PORT_OPTIONS:MDOCS}
	${MKDIR} ${STAGEDIR}${DOCSDIR}
	cd ${WRKSRC}/docs/build && ${COPYTREE_SHARE} html ${STAGEDIR}${DOCSDIR}
.endif
.if ${PORT_OPTIONS:MEXAMPLES}
	${MKDIR} ${STAGEDIR}${EXAMPLESDIR}
	cd ${WRKSRC}/examples && ${COPYTREE_SHARE} . ${STAGEDIR}${EXAMPLESDIR}
.endif

.include <bsd.port.mk>
