PORTNAME=	libsysctlmibinfo2
DISTVERSION=	2.0.1
CATEGORIES=	devel

MAINTAINER=	alfix86@gmail.com
COMMENT=	Sysctl MIB-Tree API (improved version)
WWW=		https://gitlab.com/alfix/sysctlmibinfo2/

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	${LOCALBASE}/include/sysctlinfo.h:sysutils/sysctlinfo-kmod
RUN_DEPENDS=	${KMODDIR}/sysctlbyname_improved.ko:sysutils/sysctlbyname-improved-kmod \
		${KMODDIR}/sysctlinfo.ko:sysutils/sysctlinfo-kmod

USE_LDCONFIG=	yes
USE_GITLAB=	yes

GL_ACCOUNT=	alfix
GL_PROJECT=	sysctlmibinfo2
GL_COMMIT=	de427a99fc515c22a057998a29c92221e2581592\

PLIST_FILES=	include/sysctlmibinfo2.h \
		lib/libsysctlmibinfo2.a \
		lib/libsysctlmibinfo2.so \
		lib/libsysctlmibinfo2.so.2.0.1 \
		man/man3/sysctlmibinfo2.3.gz

PORTEXAMPLES=	*

OPTIONS_DEFINE=	EXAMPLES
OPTIONS_DEFAULT=	EXAMPLES

.include <bsd.port.pre.mk>

.if ${OPSYS} == FreeBSD && ${OSVERSION} >= 1400071
IGNORE=		uses struct sysctl_oid definition previous FreeBSD 1400071
.endif

do-install:
	${INSTALL_DATA} ${WRKSRC}/sysctlmibinfo2.h ${STAGEDIR}${PREFIX}/include
	${INSTALL_DATA} ${WRKSRC}/libsysctlmibinfo2.a ${STAGEDIR}${PREFIX}/lib
	${INSTALL_LIB} ${WRKSRC}/libsysctlmibinfo2.so.2.0.1 ${STAGEDIR}${PREFIX}/lib
	${RLN} ${STAGEDIR}${PREFIX}/lib/libsysctlmibinfo2.so.2.0.1 ${STAGEDIR}${PREFIX}/lib/libsysctlmibinfo2.so
	${INSTALL_MAN} ${WRKSRC}/sysctlmibinfo2.3.gz ${STAGEDIR}${MAN3PREFIX}/man/man3

do-install-EXAMPLES-on:
	@${MKDIR} ${STAGEDIR}${EXAMPLESDIR}
.for e in ${PORTEXAMPLES}
	${INSTALL_DATA} ${WRKSRC}/examples/${e} ${STAGEDIR}${EXAMPLESDIR}
.endfor

.include <bsd.port.post.mk>
