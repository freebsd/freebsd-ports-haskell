PORTNAME=	tkhylafax
PORTVERSION=	3.2b
PORTREVISION=	6
CATEGORIES=	comms tk
MASTER_SITES=	ftp://ftp.hylafax.org/contrib/tkhylafax/
DISTNAME=	${PORTNAME}-${PORTVERSION:S/b/beta/}

MAINTAINER=	ports@FreeBSD.org
COMMENT=	Tcl/tk interface to Sam Leffler's fax package

DEPRECATED=	Depends on expired comms/hylafax
EXPIRATION_DATE=2022-12-31

RUN_DEPENDS=	sendfax:comms/hylafax \
		gv:print/gv

USES=		tk:run

WRKSRC=		${WRKDIR}/tkhylafax
MAKE_ARGS=	STAGEDIR=${STAGEDIR} PREFIX=${STAGEDIR}${PREFIX} TCLSH=${TCLSH} WISH=${WISH}

.include <bsd.port.mk>
