REGHOST := $(or ${REGHOST}, beardfish)
TAG := $(or ${TAG}, test)

DOCKER_ENV_VARS := $(or ${DOCKER_ENV_VARS}, '')

SITE := mymediawiki.org 
WWW_SITE := www.$(SITE)
EMAIL := admin@$(SITE)
DEFAULT_MEDIAWIKI_USER := $(or ${MEDIAWIKI_USER}, Guest)
DEFAULT_MEDIAWIKI_PASS := $(or ${MEDIAWIKI_PASS}, mediawiki)
MEDIAWIKI_SECRET := $(or ${MEDIAWIKI_SECRET}, '')

DB_PASSWORD := $(or ${DB_PASSWORD}, mediawiki)

ifeq ( $(DB_PASSWORD),)
	echo "Invalid DB_PASSWORD specified" || false
endif

setup-letsencrypt-ssl:
	sudo certbot --nginx -m $(EMAIL) -d $(SITE) -d $(WWW_SITE)

docker-mediawiki-build:
	SITE=$(SITE) DB_PASSWORD=$(DB_PASSWORD) REGHOST=$(REGHOST) TAG=$(TAG) MEDIAWIKI_SECRET=$(MEDIAWIKI_SECRET) \
		docker-compose -f docker-compose.yml up --build -d

docker-mediawiki-setup:
	docker exec -it mediawiki_wiki bash -x /script/install.sh $(DEFAULT_MEDIAWIKI_USER) $(DEFAULT_MEDIAWIKI_PASS)

docker-mediawiki-update:
	docker exec -it mediawiki_wiki bash -x /script/update.sh

docker-mediawiki-start:
	SITE=$(SITE) DB_PASSWORD=$(DB_PASSWORD) REGHOST=$(REGHOST) TAG=$(TAG) MEDIAWIKI_SECRET=$(MEDIAWIKI_SECRET) \
		docker-compose -f docker-compose.yml up --no-recreate -d

