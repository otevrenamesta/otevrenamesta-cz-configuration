{ lib, buildPythonPackage, fetchPypi
, attrs
, beautifulsoup4
, aiohttp
, yarl
, paho-mqtt
}:

buildPythonPackage rec {
  pname = "fbchat-asyncio";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03rciyml2i4p0sfn6gpq6fx9rvfmzc92lyi6d4sjsc0f4mi8ppij";
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
