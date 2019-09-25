{ stdenv, fetchgit, python3 }:

let

  python = python3.override {
    packageOverrides = self: super: rec {
      django = django_2_0 super;

      django-filter = python3.pkgs.buildPythonPackage rec {
        pname = "django-filter";
        version = "1.1.0";
        src = python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "0slpfqfhnjrzlrb6vmswyhrzn01p84s16j2x1xib35gg4fxg23pc";
        };
        doCheck = false;
      };
      djangorestframework-filters = python3.pkgs.buildPythonPackage rec {
        pname = "djangorestframework-filters";
        version = "0.10.2"; # FIXME try 0.11.1
        src = python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "0pc9ccvzzrxplhif0g5p0sv74dygxcgqiqhq8lcbhxpl8rdr8l8z";
        };
        buildInputs = [ django-filter super.djangorestframework ];
        doCheck = false;
      };
      openid-connect = python3.pkgs.buildPythonPackage rec {
        pname = "openid-connect";
        version = "0.5.0";
        src = python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "0j5av498a5z3hhg5privn6rzxcp40077syyh0864nf6365il0c3d";
        };
        propagatedBuildInputs = [ super.requests super.python-jose ];
        doCheck = false;
      };
      django-auth-oidc = python3.pkgs.buildPythonPackage rec {
        pname = "django-auth-oidc";
        version = "0.6.0";
        src = python3.pkgs.fetchPypi {
          inherit pname version;
          sha256 = "0asvhrm4aq3mha6dv7vllg90nakvgywbnfanmkz15njkybcpsifn";
        };
        buildInputs = [ django openid-connect super.requests ];
        doCheck = false;
      };

    };
  };

  django_2_0 = pyPkgs: pyPkgs.django_2_1.overrideDerivation (_: rec {
    pname = "Django";
    version = "2.0.13";
    name = "${pname}-${version}";
    src = pyPkgs.fetchPypi {
      inherit pname version;
      sha256 = "0bzjvm5dkjhmjjff380ggp1v8vnx2b9sapn9kgl7h1j1pi6nvr5x";
    };
  });

  myEnv = python.withPackages (p: with p; [
    pyjwkest
    psycopg2
    pyyaml
    djangorestframework
    django-filter
    djangorestframework-filters
    django
    requests
    django-auth-oidc
    openid-connect

    # for gunicorn
    gevent
    setuptools # https://github.com/benoitc/gunicorn/issues/1716
  ]);

in
stdenv.mkDerivation {
  pname = "proplaceni";
  version = "0.0.9";

  src = fetchgit {
    url = "git@gitlab.com:Jarmil/pp.git";
    rev = "584a60f56588f4b1a88a6330bbac337caea89b20"; # jh @ 2019-09-25
    sha256 = "1y6kb9k51r1i3bb27vflk9pvl3yr7l2nbq2ccazl9hjkm70ffybc";
  };
  propagatedBuildInputs = [ myEnv ];

  postPatch = ''
    cd src
    patchShebangs .
  '';

  buildPhase = ''
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out
  '';

  #doCheck = true;
  #checkPhase = ''
  #  ./manage.py mytest
  #'';

  passthru = {
    pyEnv = myEnv;
  };
}
