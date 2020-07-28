{ lib
, buildPythonApplication
, fetchFromGitHub
, aiohttp
, sqlalchemy
, alembic
, ruamel_yaml
, CommonMark
, python_magic
, pillow
, psycopg2
, setuptools

, fbchat-asyncio
, mautrix
, mautrix-facebook
}:

buildPythonApplication rec {
  pname = "mautrix-facebook";
  version = "20-06-30git";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "896736cc1ca95c84fec8fcb301356f115a9d6ac2";
    sha256 = "0ln9bp1ydgkwf995ssnjz1b4paax8i41v6m4a31qkpqxjdwzda0y";
  };

  postPatch = ''
    sed -i -e '/alembic>/d' requirements.txt
  '';

  propagatedBuildInputs = [
    aiohttp
    sqlalchemy
    ruamel_yaml
    CommonMark
    python_magic
    mautrix
    fbchat-asyncio
    pillow
    psycopg2
    setuptools
  ];

  doCheck = false;

  # `alembic` (a database migration tool) is only needed for the initial setup,
  # and not needed during the actual runtime. However `alembic` requires `mautrix-facebook`
  # in its environment to create a database schema from all models.
  #
  # Hence we need to patch away `alembic` from `mautrix-facebook` and create an `alembic`
  # which has `mautrix-facebook` in its environment.
  passthru.alembic = alembic.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      mautrix-facebook
    ];
  });

  meta = with lib; {
    description = "Matrix-Facebook Messenger puppeting bridge";
    homepage = "https://github.com/tulir/mautrix-facebook";
    maintainers = with maintainers; [ mmilata ];
    license = licenses.agpl3Plus;
  };
}
