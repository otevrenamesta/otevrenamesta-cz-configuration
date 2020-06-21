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
  version = "20-06-19git";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "acdb531814af7d8386b94cc0265c80d9d3c4a8cf";
    sha256 = "09za0jd0mi463pkpx2174hvgm2d4djdcgjwb1590rj3vlzcipyf8";
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
