PORTNAME=	orange3-timeseries
DISTVERSION=	0.3.10
CATEGORIES=	misc python
PKGNAMEPREFIX=	${PYTHON_PKGNAMEPREFIX}

MAINTAINER=	yuri@FreeBSD.org
COMMENT=	Orange add-on for analyzing, visualizing, manipulating time series
WWW=		https://github.com/biolab/orange3-timeseries

LICENSE=	CC-BY-3.0
LICENSE_FILE=	${WRKSRC}/LICENSE

DEPRECATED=	Depends on expired security/py-keyrings.alt (via msic/orange3)
EXPIRATION_DATE=2022-12-31

RUN_DEPENDS=	orange3>0:misc/orange3 \
		${PYNUMPY} \
		${PYTHON_PKGNAMEPREFIX}more-itertools>0:devel/py-more-itertools@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}pandas>0:math/py-pandas@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}pandas-datareader>0:math/py-pandas-datareader@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}scipy>=0.17:science/py-scipy@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}statsmodels>=0.10.0:math/py-statsmodels@${PY_FLAVOR}

USES=		python:3.7+
USE_GITHUB=	yes
GH_ACCOUNT=	biolab
USE_PYTHON=	distutils autoplist
NO_ARCH=	yes

.include <bsd.port.mk>
