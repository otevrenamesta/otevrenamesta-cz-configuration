{ lib, buildPythonPackage, fetchPypi
, attrs
, beautifulsoup4
, aiohttp
, yarl
, paho-mqtt
}:

buildPythonPackage rec {
  pname = "fbchat-asyncio";
  version = "0.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h26i7rsmvdj1qf5hmkx0ghknwbqs0rh9n93nc2zvc8v459aanxk";
  };

  propagatedBuildInputs = [
    attrs
    beautifulsoup4
    aiohttp
    yarl
    paho-mqtt
  ];

  # AttributeError: module 'fbchat' has no attribute '_fix_module_metadata'
  doCheck = false;

  meta = with lib; {
    description = "Facebook Messenger library for Python/Asyncio";
    homepage    = "https://github.com/tulir/fbchat-asyncio";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ mmilata ];
  };
}
