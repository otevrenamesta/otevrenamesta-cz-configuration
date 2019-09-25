# -*- encoding:utf-8 -*-
"""
    Application local settings:
        - database
        - server connections
"""

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'u0Q8B77eusqQtFOClDmcwvR1qf0eyj/12B66KHzQqUQoVByBicOP'

#  Nastaveni databaze. Defaultne je nastaveno na postgresql uzivatele a databazi
#  vytvorenou pri behu install.sh 
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',  # Add 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'proplaceni',                       # Or path to database file if using sqlite3.
        'USER': 'proplaceni',                       # Not used with sqlite3.
        'PASSWORD': 'dummy',                        # Not used with sqlite3.
        #'HOST': '/var/run/postgresql',              # Set to empty string for localhost. Not used with sqlite3.
        'PORT': '5432',                             # Set to empty string for default. Not used with sqlite3.
    }
}

##
# Email setup
##
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

#   Update config array with these values
UPDATE_CONFIGS = [
    #('CACHES', 'default', 'LOCATION', '/var/run/memcached/memcached.sock'),
    ('CACHES', 'default', 'KEY_PREFIX', 'mainApp:'),
    ('AUTH_CLIENT_ID','mainApp'),
    ('AUTH_CLIENT_SECRET',''),  # Client secret z Keycloaku, zalozka Client, Credentials
    ('AUTH_SSO_LOCALE', 'cs'),
    # Mozne autentizacni sluzby. Nektere hodnoty lze vynechat, ale nesmi se zmenit jejich poradi:
    ('AUTH_AVAIL_IDP',('pirati', 'twitter', 'facebook', 'google')),  

    # HACK: pokud ostry server nedostava HTTP_X_FORWARDED_HOST, nevi, na jakou adresu ma pozadat MojeID o zpetne presmerovani
    # je treba ho tedy zadat rucne. Tato url musi byt zadana v konfiguraci MojeID, presne vcetne koncoveho lomitka
    # ('AUTH_FORCED_REDIRECT_URI','https://mojedomena.cz/sso/done/'),     

]

AUTH_ENGINE = 'mojeid'              # jake SSO zajistuje autentizaci? jedno z 'nalodeni', 'mojeid'
LOG_INCOMING_REQUESTS = False
DEBUG_LOCAL=False

# Prizpusobeni vzhledu www aplikace konkretni organizaci.
# definujete-li toto pole, musite vyplnit vsechny polozky
# krome tohoto seznamu je nutno jeste nastavit polozku v TEMPLATES, viz nize
TEXTS  = {
    'NAME': "OtevZeLho",      # jmeno aplikace
    'ASSETS_DIR': "om",   # cesta k adresari s obrazky a CSS jako podadresar /src/piructo/static/
    'INDEX_TEXT': """<h3>Vítejte v Otevřené Zelené Lhotě</h3>
          <p>
          Tady najdete vyúčtovanou každou korunu, kterou rada městyse utratila z Vašich daní.
          </p>""",     # text na uvodni stranku, muze obsahovat HTML znacky

    'AUTH_SERVICENAME': "MojeID", # jmeno prihlasovaci sluzby 

    # dodatecny radek na strance profilu uzivatele, pod informaci o zmene hesla, podporuje HTML       
    'USER_PROFILE_MOREINFO': """""",

    # Texty do zahlavi nekterych stranek
    'HDRINFO_ZADOST_NEW': "Žádosti o proplacení podávejte včas",
    'HDRINFO_ZADOST_DETAIL': """Toto je <b>žádost o proplacení</b>. Na základě žádosti proplácíme z rozpočtu
    městyse občasnům výdaje, které vynaloží v souvislosti se správou městyse a 
    souhlasem orgánů hospodařících s rozpočtem. Odpovídající transakce je 
    dohledatelná na transparentním bankovním účtu pod uvedeným datem proplacení a názvem záměru.""",    
    'HDRINFO_SMLOUVY': """Upozornění: tato evidence <b>NENAHRAZUJE</b> <a href="https://smlouvy.zelena-lhota.cz">registr smluv</a>!""",
    'HDRINFO_BANK_ACCOUNTS': "Seznam bankovních účtů Zelené lhoty.",
}


# konstrukce nutna pro nacitani hlavniho template z jineho nez defaultniho adresare. 
# pri customizaci modifikuj polozku 'DIRS' na spravny adresar s assets, v nem bude hledan soubor template.html
# doc: https://docs.djangoproject.com/en/dev/ref/settings/#std:setting-TEMPLATES
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'APP_DIRS': True,
        'DIRS': [ '/var/lib/proplaceni/static_files/om'],
    },
]


# Ucty a pristupova prava k nim
FIO_ACCOUNTS = {
    "your-account-number-without-bank-code": { "token": "account-access-token-here" }
}


GROUP_MEMBERS_TOKEN = "place the token here"
GROUP_MEMBERS_TOKEN_NAME = "token_name"


# je-li nastaveno na True, vynecha stranku s vyberem Instituce, Uctu apod
# v pripade, ze existuje pouze jedna polozka daneho typu.
# POZOR: na strance vyberu je obvykle rovnez odkaz pro pridani dalsi polozky (Instituce, Uctu...)
# ktery tudiz nebude nikde zobrazen (ale bude se dal dat zavolat modifikaci URL)
SKIP_1CHOICE_INSTITUTION = False
SKIP_1CHOICE_BANK = False
SKIP_1CHOICE_BUDGET = False

# Zde lze definovat cislo rozpoctove skladby, pod niz budou zahrnuty vsechny
# polozky rozpoctu a  vsechny zamery. Pokud je definovana, nebude v prislusnych editacich 
# nabizena polozka "Skladba". Zaroven bude pri startu aplikace proveden check, zda 
# dana skladba existuje a zda nejsou inkonzistence v databazi (polozky a zamery v jine skladbe)
# Neni-li definovana, vybira se skladba pri editaci.
# DEFAULT_SKLADBA=999

# mapovani uzivatelskych roli. Zde prirad role uzivatelum, prihlasovanym pres 
# sso neposkytujici role (napriklad MojeID)
# klicem je nazev role, hodnotou set uzivatelskych emailu, ktere tuto roli maji
USER_ROLES_MAPPING = {
     # hospodari
     #'sso_finman': ( 'john_doe@example.com', ),
     # proplaceci
     #'sso_cashier': ( 'john_doe@example.com', ),
     # zrejme contract manager
     #'sso_contrman': ( 'john_doe@example.com', ),
     # spravce - programator...
     #'sso_techman': ( 'john_doe@example.com', ),
}

