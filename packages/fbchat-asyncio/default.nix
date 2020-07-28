{ lib, buildPythonPackage, fetchPypi
, attrs
, beautifulsoup4
, aiohttp
, yarl
, paho-mqtt
}:

buildPythonPackage rec {
  pname = "fbchat-asyncio";
  version = "0.6.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "131km9vpsw6j75g7hxq7b9sx21k06rbf88gfb9svl092x1n33jjv";
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
