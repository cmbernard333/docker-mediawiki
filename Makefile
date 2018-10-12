REGHOST := $(or ${REGHOST}, beardfish)
TAG := $(or ${TAG}, test)

SITE := kepler-wiki.duckdns.org
WWW_SITE := www.$(SITE)
EMAIL := cmbernard333@gmail.com
DEFAULT_MEDIAWIKI_USER := $(or ${MEDIAWIKI_USER}, mediawiki)
DEFAULT_MEDIAWIKI_PASS := $(or ${MEDIAWIKI_PASS}, mediawiki)

DB_PASSWORD := $( or ${DB_PASSWORD}, '' )

ifeq ( $(DB_PASSWORD), '' )
    echo "Invalid DB_PASSWORD specified" || false
endif

setup-letsencrypt-ssl:
	sudo certbot --nginx -m $(EMAIL) -d $(SITE) -d $(WWW_SITE)

docker-mediawiki-build:
	DB_PASSWORD=$(DB_PASSWORD) REGHOST=$(REGHOST) TAG=$(TAG) docker-compose -f docker-compose.yml up --build -d
	docker exec -it mediawiki_wiki /script/install.sh $(DEFAULT_MEDIAWIKI_USER) $(DEFAULT_MEDIAWIKI_PASS)

docker-mediawiki-up:
	docker-compose -f docker-compose-yml up -d
