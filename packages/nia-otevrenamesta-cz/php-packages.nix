{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aura/intl" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aura-intl-7fce228980b19bf4dee2d7bbd6202a69b0dde926";
        src = fetchurl {
          url = https://api.github.com/repos/auraphp/Aura.Intl/zipball/7fce228980b19bf4dee2d7bbd6202a69b0dde926;
          sha256 = "05aaba8rqkx33bdy8j425nxr6q6yys8di79y6kfmmbgxlkjj7fn9";
        };
      };
    };
    "cakephp/cakephp" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cakephp-cakephp-34833a0c02fc1fc21e27ceb69cf7b4f7c131a3cc";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/cakephp/zipball/34833a0c02fc1fc21e27ceb69cf7b4f7c131a3cc;
          sha256 = "17810lfl2344m1rgnn6vpkvbja7sl4rkrfgy6f86659dc0g1y3xn";
        };
      };
    };
    "cakephp/chronos" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cakephp-chronos-0292f06e8cc23fc82f0574889da2d8bf27b613c1";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/chronos/zipball/0292f06e8cc23fc82f0574889da2d8bf27b613c1;
          sha256 = "1m41rxyqdcb7yh0s8zp9gmbkcfv7f0wiapj1qwl8haj8rk4qc3qz";
        };
      };
    };
    "cakephp/migrations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cakephp-migrations-643e54e627e876c10b5ffa1c706a6819aa6a70b9";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/migrations/zipball/643e54e627e876c10b5ffa1c706a6819aa6a70b9;
          sha256 = "0zw3lcgb956lfjv099l3qrm6c0s33pwjh89zcx44wrbyhlh6y3c3";
        };
      };
    };
    "cakephp/plugin-installer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cakephp-plugin-installer-af9711ee5dfbe62a76e8aa86cb348895fab23b50";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/plugin-installer/zipball/af9711ee5dfbe62a76e8aa86cb348895fab23b50;
          sha256 = "1q0r59kwcy7vf3rnl7400xd2qfbz8wnj5j92in22f35gwmb0j4gm";
        };
      };
    };
    "mobiledetect/mobiledetectlib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mobiledetect-mobiledetectlib-6f8113f57a508494ca36acbcfa2dc2d923c7ed5b";
        src = fetchurl {
          url = https://api.github.com/repos/serbanghita/Mobile-Detect/zipball/6f8113f57a508494ca36acbcfa2dc2d923c7ed5b;
          sha256 = "0cf40xla0dw382cfm51627wrzzypq59s7skcznspn14bdcjsvbmx";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-b7ce3b176482dbbc1245ebf52b181af44c2cf55f";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/container/zipball/b7ce3b176482dbbc1245ebf52b181af44c2cf55f;
          sha256 = "0rkz64vgwb0gfi09klvgay4qnw993l1dc03vyip7d7m2zxi6cy4j";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-f6561bf28d520154e4b0ec72be95418abe6d9363";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/http-message/zipball/f6561bf28d520154e4b0ec72be95418abe6d9363;
          sha256 = "195dd67hva9bmr52iadr4kyp2gw2f5l51lplfiay2pv6l9y4cf45";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-446d54b4cb6bf489fc9d75f55843658e6f25d801";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/log/zipball/446d54b4cb6bf489fc9d75f55843658e6f25d801;
          sha256 = "04baykaig5nmxsrwmzmcwbs60ixilcx1n0r9wdcnvxnnj64cf2kr";
        };
      };
    };
    "psr/simple-cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-simple-cache-408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/simple-cache/zipball/408d5eafb83c57f6365a3ca330ff23aa4a5fa39b;
          sha256 = "1djgzclkamjxi9jy4m9ggfzgq1vqxaga2ip7l3cj88p7rwkzjxgw";
        };
      };
    };
    "robmorgan/phinx" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "robmorgan-phinx-a6cced878695d26396b26dfd62ce300aea07de05";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/phinx/zipball/a6cced878695d26396b26dfd62ce300aea07de05;
          sha256 = "03vv12mczw8j86l9s2y618kkdl7w2ar7fklslm8mjh5hffj9cw71";
        };
      };
    };
    "robrichards/xmlseclibs" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "robrichards-xmlseclibs-0a53d3c3aa87564910cae4ed01416441d3ae0db5";
        src = fetchurl {
          url = https://api.github.com/repos/robrichards/xmlseclibs/zipball/0a53d3c3aa87564910cae4ed01416441d3ae0db5;
          sha256 = "1lzvjk4k8z7yv6njylzyq6gjzh1fpf3gidsjdxw2hwglvsiklkfb";
        };
      };
    };
    "simplesamlphp/saml2" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "simplesamlphp-saml2-2f753c70e3dc5e958e9b391daf70b7ec9100db3e";
        src = fetchurl {
          url = https://api.github.com/repos/simplesamlphp/saml2/zipball/2f753c70e3dc5e958e9b391daf70b7ec9100db3e;
          sha256 = "19vpavpr0ch1xs0vagjv120c1psdp6zqahp4spwibjb2mg50an63";
        };
      };
    };
    "symfony/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-config-f08e1c48e1f05d07c32f2d8599ed539e62105beb";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/config/zipball/f08e1c48e1f05d07c32f2d8599ed539e62105beb;
          sha256 = "0mamyy4g5q3pssrn012wwc0sirjkwk36lvwvvk5f0nssyc240z7s";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-35d9077f495c6d184d9930f7a7ecbd1ad13c7ab8";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/35d9077f495c6d184d9930f7a7ecbd1ad13c7ab8;
          sha256 = "13zj2gpll8smnxxsjpjxyk3k6gwp16pq98svs65h88h4qj8y1d43";
        };
      };
    };
    "symfony/filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-filesystem-d12b01cba60be77b583c9af660007211e3909854";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/filesystem/zipball/d12b01cba60be77b583c9af660007211e3909854;
          sha256 = "08414vzy7amyr3x2daxh9fviga6wgz81w7yv60gw33a1135l6q44";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-f8f0b461be3385e56d6de3dbb5a0df24c0c275e3";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/f8f0b461be3385e56d6de3dbb5a0df24c0c275e3;
          sha256 = "056md08sxcanwp4aib9z376aq27x575n08phw3sg9mlafcyp4nii";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-7b4aab9743c30be783b73de055d24a39cf4b954f";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/7b4aab9743c30be783b73de055d24a39cf4b954f;
          sha256 = "0q3d4xyj83zsqsmpj8700ygsphd5sd8x8jhmfn463gzb03f8ihj3";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-4b0e2222c55a25b4541305a053013d5647d3a25f";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php73/zipball/4b0e2222c55a25b4541305a053013d5647d3a25f;
          sha256 = "1535827czfpiq1x7kcwiavj9m247gpll8z7zrby5s1qpsphy3dhs";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-9d99e1556417bf227a62e14856d630672bf10eaf";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/service-contracts/zipball/9d99e1556417bf227a62e14856d630672bf10eaf;
          sha256 = "0rzxycshayxzin62yggyrfwqqgi1q3xf3hrcf2286psnfasjy926";
        };
      };
    };
    "symfony/yaml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-yaml-76de473358fe802578a415d5bb43c296cf09d211";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/yaml/zipball/76de473358fe802578a415d5bb43c296cf09d211;
          sha256 = "0xcqj5ikfj46gcqr1w5c26l0kfvf00brkgwdmzmz071rdws34s91";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-573381c0a64f155a0d9a23f4b0c797194805b925";
        src = fetchurl {
          url = https://api.github.com/repos/webmozart/assert/zipball/573381c0a64f155a0d9a23f4b0c797194805b925;
          sha256 = "0pnxl10afp5q8hnnffbnr3z0dg0ddk6x05yzj5334bvzr63msvpz";
        };
      };
    };
    "zendframework/zend-diactoros" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "zendframework-zend-diactoros-a85e67b86e9b8520d07e6415fcbcb8391b44a75b";
        src = fetchurl {
          url = https://api.github.com/repos/zendframework/zend-diactoros/zipball/a85e67b86e9b8520d07e6415fcbcb8391b44a75b;
          sha256 = "0y9syp9zmb5awjiqmdvvyz5yh743mcqn9bgy1ix2x2lasr730pm8";
        };
      };
    };
  };
  devPackages = {
    "ajgl/breakpoint-twig-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ajgl-breakpoint-twig-extension-13ee39406dc3d959c5704b462a3dbc3cbf088f16";
        src = fetchurl {
          url = https://api.github.com/repos/ajgarlag/AjglBreakpointTwigExtension/zipball/13ee39406dc3d959c5704b462a3dbc3cbf088f16;
          sha256 = "15rw0yqh8rzgski17h1pq0fpnl0bxm7gf947cwgfi7nl93y2j5hh";
        };
      };
    };
    "aptoma/twig-markdown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aptoma-twig-markdown-64a9c5c7418c08faf91c4410b34bdb65fb25c23d";
        src = fetchurl {
          url = https://api.github.com/repos/aptoma/twig-markdown/zipball/64a9c5c7418c08faf91c4410b34bdb65fb25c23d;
          sha256 = "02pwl81nfinlaq8ijyd1jd9wxisy0sjb2dldd1cwxgqhg24wiqa4";
        };
      };
    };
    "asm89/twig-cache-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "asm89-twig-cache-extension-630ea7abdc3fc62ba6786c02590a1560e449cf55";
        src = fetchurl {
          url = https://api.github.com/repos/asm89/twig-cache-extension/zipball/630ea7abdc3fc62ba6786c02590a1560e449cf55;
          sha256 = "0v8yjkg83qmbghb5jz9iq3ciq7gjb5273my0kh15lp5v1n5d2prg";
        };
      };
    };
    "cakephp/bake" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cakephp-bake-8598c3326541a16aa7b003ce322c44a34f90ad85";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/bake/zipball/8598c3326541a16aa7b003ce322c44a34f90ad85;
          sha256 = "16ipidbfy7hzchdbx1hq15py2rkzyggxc0qya84hn5yrzmqgy74d";
        };
      };
    };
    "cakephp/cakephp-codesniffer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cakephp-cakephp-codesniffer-65ce18f4959d89f0bcbd8d1517734c68606a8186";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/cakephp-codesniffer/zipball/65ce18f4959d89f0bcbd8d1517734c68606a8186;
          sha256 = "1ld7fr3jchpgm96glbr4vkizkz93dlyz3fdnxcn7sx11y1pph4h8";
        };
      };
    };
    "cakephp/debug_kit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cakephp-debug_kit-74c289cbd9ee07a531ce813dec744c9f2f472e14";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/debug_kit/zipball/74c289cbd9ee07a531ce813dec744c9f2f472e14;
          sha256 = "0fxhchvlcki0q5z7p986p675f14121b4d0m2v8lzkwlwg8l5k7ra";
        };
      };
    };
    "composer/ca-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-ca-bundle-10bb96592168a0f8e8f6dcde3532d9fa50b0b527";
        src = fetchurl {
          url = https://api.github.com/repos/composer/ca-bundle/zipball/10bb96592168a0f8e8f6dcde3532d9fa50b0b527;
          sha256 = "0p0mzwbs4lw3y85y5mypj2dsgcibwl6ifs7pi1dx1qmy3bsvzcny";
        };
      };
    };
    "composer/composer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-composer-bb01f2180df87ce7992b8331a68904f80439dd2f";
        src = fetchurl {
          url = https://api.github.com/repos/composer/composer/zipball/bb01f2180df87ce7992b8331a68904f80439dd2f;
          sha256 = "0qxpq0b2jiyz7r3rykprb2cxq1l1mf2qbk4dfzg20vamm3zi8zg4";
        };
      };
    };
    "composer/semver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-semver-46d9139568ccb8d9e7cdd4539cab7347568a5e2e";
        src = fetchurl {
          url = https://api.github.com/repos/composer/semver/zipball/46d9139568ccb8d9e7cdd4539cab7347568a5e2e;
          sha256 = "11nq81abq684v12xfv6xg2y6h8fhyn76s50hvacs51sqqs926i0d";
        };
      };
    };
    "composer/spdx-licenses" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-spdx-licenses-7ac1e6aec371357df067f8a688c3d6974df68fa5";
        src = fetchurl {
          url = https://api.github.com/repos/composer/spdx-licenses/zipball/7ac1e6aec371357df067f8a688c3d6974df68fa5;
          sha256 = "1j61v4vjk5yfjxm9ha62f6hn561z75lja3b0b1ghgkjys82734d3";
        };
      };
    };
    "composer/xdebug-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-xdebug-handler-cbe23383749496fe0f373345208b79568e4bc248";
        src = fetchurl {
          url = https://api.github.com/repos/composer/xdebug-handler/zipball/cbe23383749496fe0f373345208b79568e4bc248;
          sha256 = "0shf0q79fkzqvwpb8gn8fgwpm5bhzj5acwayilgdsasr506jsr2l";
        };
      };
    };
    "dnoegel/php-xdg-base-dir" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dnoegel-php-xdg-base-dir-265b8593498b997dc2d31e75b89f053b5cc9621a";
        src = fetchurl {
          url = https://api.github.com/repos/dnoegel/php-xdg-base-dir/zipball/265b8593498b997dc2d31e75b89f053b5cc9621a;
          sha256 = "1xkzxi7j589ayvx1669qaybamravfawz6hc6im32v8vkkbng5kva";
        };
      };
    };
    "doctrine/instantiator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-instantiator-ae466f726242e637cebdd526a7d991b9433bacf1";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/instantiator/zipball/ae466f726242e637cebdd526a7d991b9433bacf1;
          sha256 = "1dzx7ql2qjkk902g02salvz0yarf1a17q514l3y6rqg53i3rmxp7";
        };
      };
    };
    "jakub-onderka/php-console-color" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jakub-onderka-php-console-color-d5deaecff52a0d61ccb613bb3804088da0307191";
        src = fetchurl {
          url = https://api.github.com/repos/JakubOnderka/PHP-Console-Color/zipball/d5deaecff52a0d61ccb613bb3804088da0307191;
          sha256 = "0ih1sa301sda03vqsbg28mz44azii1l0adsjp94p6lhgaawyj4rn";
        };
      };
    };
    "jakub-onderka/php-console-highlighter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jakub-onderka-php-console-highlighter-9f7a229a69d52506914b4bc61bfdb199d90c5547";
        src = fetchurl {
          url = https://api.github.com/repos/JakubOnderka/PHP-Console-Highlighter/zipball/9f7a229a69d52506914b4bc61bfdb199d90c5547;
          sha256 = "1wgk540dkk514vb6azn84mygxy92myi1y27l9la6q24h0hb96514";
        };
      };
    };
    "jasny/twig-extensions" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jasny-twig-extensions-30bdf3a3903c021544f36332c9d5d4d563527da4";
        src = fetchurl {
          url = https://api.github.com/repos/jasny/twig-extensions/zipball/30bdf3a3903c021544f36332c9d5d4d563527da4;
          sha256 = "067lkrgbgdsj92b2i1snbqlr5gwk7c024n95ydhmyx19w62lxkn0";
        };
      };
    };
    "jdorn/sql-formatter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jdorn-sql-formatter-64990d96e0959dff8e059dfcdc1af130728d92bc";
        src = fetchurl {
          url = https://api.github.com/repos/jdorn/sql-formatter/zipball/64990d96e0959dff8e059dfcdc1af130728d92bc;
          sha256 = "1dnmkm8mxylvxjwi0bdkzrlklncqx92fa4fwqp5bh2ypj8gaagzi";
        };
      };
    };
    "josegonzalez/dotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "josegonzalez-dotenv-f19174d9d7213a6c20e8e5e268aa7dd042d821ca";
        src = fetchurl {
          url = https://api.github.com/repos/josegonzalez/php-dotenv/zipball/f19174d9d7213a6c20e8e5e268aa7dd042d821ca;
          sha256 = "05332v80v3cwdfbf0jlw95s50yjf0qmd1x60iicpnhpjp3rfnp9p";
        };
      };
    };
    "justinrainbow/json-schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "justinrainbow-json-schema-44c6787311242a979fa15c704327c20e7221a0e4";
        src = fetchurl {
          url = https://api.github.com/repos/justinrainbow/json-schema/zipball/44c6787311242a979fa15c704327c20e7221a0e4;
          sha256 = "12a75nyv59pd8kx18w7vlsp2xwwjk9ynbzkkx56mcf1payinwpr1";
        };
      };
    };
    "m1/env" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "m1-env-294addeedf15e1149eeb96ec829f2029d2017d39";
        src = fetchurl {
          url = https://api.github.com/repos/m1/Env/zipball/294addeedf15e1149eeb96ec829f2029d2017d39;
          sha256 = "0isc0x2a703xlqnr93fnih32x1chvxxskl7g48wvwzppzrfm0020";
        };
      };
    };
    "myclabs/deep-copy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "myclabs-deep-copy-007c053ae6f31bba39dfa19a7726f56e9763bbea";
        src = fetchurl {
          url = https://api.github.com/repos/myclabs/DeepCopy/zipball/007c053ae6f31bba39dfa19a7726f56e9763bbea;
          sha256 = "107q8mf4rls3aqq9y4f1k8xvcc28b9rpg792cz14fl734m759yb5";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-9a9981c347c5c49d6dfe5cf826bb882b824080dc";
        src = fetchurl {
          url = https://api.github.com/repos/nikic/PHP-Parser/zipball/9a9981c347c5c49d6dfe5cf826bb882b824080dc;
          sha256 = "1qk8g51sxh8vm9b2w98383045ig20g71p67izw7vrsazqljmxxyb";
        };
      };
    };
    "phar-io/manifest" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-manifest-2df402786ab5368a0169091f61a7c1e0eb6852d0";
        src = fetchurl {
          url = https://api.github.com/repos/phar-io/manifest/zipball/2df402786ab5368a0169091f61a7c1e0eb6852d0;
          sha256 = "0l6n4z4mx84xbc0bjjyf0gxn3c1x2vq9aals46yj98wywp4sj7hx";
        };
      };
    };
    "phar-io/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-version-a70c0ced4be299a63d32fa96d9281d03e94041df";
        src = fetchurl {
          url = https://api.github.com/repos/phar-io/version/zipball/a70c0ced4be299a63d32fa96d9281d03e94041df;
          sha256 = "07arsyb38pczdzvmnz785yf34rza6znv3z6db6y9d1yfyfrx6dix";
        };
      };
    };
    "phpdocumentor/reflection-common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-common-63a995caa1ca9e5590304cd845c15ad6d482a62a";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/ReflectionCommon/zipball/63a995caa1ca9e5590304cd845c15ad6d482a62a;
          sha256 = "1fcyb675bwf9a1gjmxg0v549jjy5n16rfm0c13c5h5clz8ivfjca";
        };
      };
    };
    "phpdocumentor/reflection-docblock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-docblock-b83ff7cfcfee7827e1e78b637a5904fe6a96698e";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/ReflectionDocBlock/zipball/b83ff7cfcfee7827e1e78b637a5904fe6a96698e;
          sha256 = "0wzbcf035fyyn6awf6fzdnhbbi7w8xbdfmqn9hln381k87lsillm";
        };
      };
    };
    "phpdocumentor/type-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-type-resolver-2e32a6d48972b2c1976ed5d8967145b6cec4a4a9";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/TypeResolver/zipball/2e32a6d48972b2c1976ed5d8967145b6cec4a4a9;
          sha256 = "17iywfpk7nf2lasb94fcbyi0fjs30fp49mqii2s8bjdwqc7gp8j4";
        };
      };
    };
    "phpspec/prophecy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpspec-prophecy-f6811d96d97bdf400077a0cc100ae56aa32b9203";
        src = fetchurl {
          url = https://api.github.com/repos/phpspec/prophecy/zipball/f6811d96d97bdf400077a0cc100ae56aa32b9203;
          sha256 = "16mgpavjd38knmvi7aqay8ai0zmncgxjdblnpb60xi83scgcs458";
        };
      };
    };
    "phpunit/php-code-coverage" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-code-coverage-c89677919c5dd6d3b3852f230a663118762218ac";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-code-coverage/zipball/c89677919c5dd6d3b3852f230a663118762218ac;
          sha256 = "1rcph2077zgnsib7bgb9d7ik64xyzrddzrx23im8829qdfk51s4a";
        };
      };
    };
    "phpunit/php-file-iterator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-file-iterator-730b01bc3e867237eaac355e06a36b85dd93a8b4";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-file-iterator/zipball/730b01bc3e867237eaac355e06a36b85dd93a8b4;
          sha256 = "0kbg907g9hrx7pv8v0wnf4ifqywdgvigq6y6z00lyhgd0b8is060";
        };
      };
    };
    "phpunit/php-text-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-text-template-31f8b717e51d9a2afca6c9f046f5d69fc27c8686";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-text-template/zipball/31f8b717e51d9a2afca6c9f046f5d69fc27c8686;
          sha256 = "1y03m38qqvsbvyakd72v4dram81dw3swyn5jpss153i5nmqr4p76";
        };
      };
    };
    "phpunit/php-timer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-timer-3dcf38ca72b158baf0bc245e9184d3fdffa9c46f";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-timer/zipball/3dcf38ca72b158baf0bc245e9184d3fdffa9c46f;
          sha256 = "1j04r0hqzrv6m1jk5nb92k2nnana72nscqpfk3rgv3fzrrv69ljr";
        };
      };
    };
    "phpunit/php-token-stream" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-token-stream-791198a2c6254db10131eecfe8c06670700904db";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-token-stream/zipball/791198a2c6254db10131eecfe8c06670700904db;
          sha256 = "03i9259r9mjib2ipdkavkq6di66mrsga6kzc7rq5pglrhfiiil4s";
        };
      };
    };
    "phpunit/phpunit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-phpunit-bac23fe7ff13dbdb461481f706f0e9fe746334b7";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/phpunit/zipball/bac23fe7ff13dbdb461481f706f0e9fe746334b7;
          sha256 = "1vhjfsh9jyk6dvihxzzh2vg2lw54ja1g4649vgd7fp9q4jwh1czq";
        };
      };
    };
    "phpunit/phpunit-mock-objects" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-phpunit-mock-objects-cd1cf05c553ecfec36b170070573e540b67d3f1f";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/phpunit-mock-objects/zipball/cd1cf05c553ecfec36b170070573e540b67d3f1f;
          sha256 = "0b987ra0ayz2pk78c9w2dpg4kzy2yys065p6ha6gxq2sq7s84yhk";
        };
      };
    };
    "psy/psysh" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psy-psysh-75d9ac1c16db676de27ab554a4152b594be4748e";
        src = fetchurl {
          url = https://api.github.com/repos/bobthecow/psysh/zipball/75d9ac1c16db676de27ab554a4152b594be4748e;
          sha256 = "0a188zgi1y5zxa4m0y9yq8fnrci74v2c667a8vsyyhf2c99dy22y";
        };
      };
    };
    "sebastian/code-unit-reverse-lookup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-reverse-lookup-4419fcdb5eabb9caa61a27c7a1db532a6b55dd18";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/code-unit-reverse-lookup/zipball/4419fcdb5eabb9caa61a27c7a1db532a6b55dd18;
          sha256 = "0n0bygv2vx1l7af8szbcbn5bpr4axrgvkzd0m348m8ckmk8akvs8";
        };
      };
    };
    "sebastian/comparator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-comparator-34369daee48eafb2651bea869b4b15d75ccc35f9";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/comparator/zipball/34369daee48eafb2651bea869b4b15d75ccc35f9;
          sha256 = "1l4kyl916gjqg2dj5xyqh951khx5zgi14bslw0319pmk1a2mzlx8";
        };
      };
    };
    "sebastian/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-diff-347c1d8b49c5c3ee30c7040ea6fc446790e6bddd";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/diff/zipball/347c1d8b49c5c3ee30c7040ea6fc446790e6bddd;
          sha256 = "0bca0q624zjwm555irbb2vv0y6dy0plbh01nlp74bxzmd3lra88a";
        };
      };
    };
    "sebastian/environment" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-environment-cd0871b3975fb7fc44d11314fd1ee20925fce4f5";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/environment/zipball/cd0871b3975fb7fc44d11314fd1ee20925fce4f5;
          sha256 = "1b2jgfi67xmspijyzrgn23cycdw0rkfx5q3llhvz6gkwyxgmqxnm";
        };
      };
    };
    "sebastian/exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-exporter-68609e1261d215ea5b21b7987539cbfbe156ec3e";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/exporter/zipball/68609e1261d215ea5b21b7987539cbfbe156ec3e;
          sha256 = "0i8a502xqf2ripwbr5rgw9z49z9as7fjibh7sr171q0h4yrrr02j";
        };
      };
    };
    "sebastian/global-state" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-global-state-e8ba02eed7bbbb9e59e43dedd3dddeff4a56b0c4";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/global-state/zipball/e8ba02eed7bbbb9e59e43dedd3dddeff4a56b0c4;
          sha256 = "1489kfvz0gg6jprakr43mjkminlhpsimcdrrxkmsm6mmhahbgjnf";
        };
      };
    };
    "sebastian/object-enumerator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-enumerator-7cfd9e65d11ffb5af41198476395774d4c8a84c5";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/object-enumerator/zipball/7cfd9e65d11ffb5af41198476395774d4c8a84c5;
          sha256 = "00z5wzh19z1drnh52d27gflqm7dyisp96c29zyxrgsdccv1wss3m";
        };
      };
    };
    "sebastian/object-reflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-reflector-773f97c67f28de00d397be301821b06708fca0be";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/object-reflector/zipball/773f97c67f28de00d397be301821b06708fca0be;
          sha256 = "1rq5wwf7smdbbz3mj46hmjc643bbsm2b6cnnggmawyls479qmxlk";
        };
      };
    };
    "sebastian/recursion-context" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-recursion-context-5b0cd723502bac3b006cbf3dbf7a1e3fcefe4fa8";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/recursion-context/zipball/5b0cd723502bac3b006cbf3dbf7a1e3fcefe4fa8;
          sha256 = "0p4j54bxriciw67g7l8zy1wa472di0b8f8mxs4fdvm37asz2s6vd";
        };
      };
    };
    "sebastian/resource-operations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-resource-operations-ce990bb21759f94aeafd30209e8cfcdfa8bc3f52";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/resource-operations/zipball/ce990bb21759f94aeafd30209e8cfcdfa8bc3f52;
          sha256 = "19jfc8xzkyycglrcz85sv3ajmxvxwkw4sid5l4i8g6wmz9npbsxl";
        };
      };
    };
    "sebastian/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-version-99732be0ddb3361e16ad77b68ba41efc8e979019";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/version/zipball/99732be0ddb3361e16ad77b68ba41efc8e979019;
          sha256 = "0wrw5hskz2hg5aph9r1fhnngfrcvhws1pgs0lfrwindy066z6fj7";
        };
      };
    };
    "seld/jsonlint" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "seld-jsonlint-e2e5d290e4d2a4f0eb449f510071392e00e10d19";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/jsonlint/zipball/e2e5d290e4d2a4f0eb449f510071392e00e10d19;
          sha256 = "10y2d9fjmhnvr9sclmc1phkasplg0iczvj7d2y6i3x3jinb9sgnb";
        };
      };
    };
    "seld/phar-utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "seld-phar-utils-7009b5139491975ef6486545a39f3e6dad5ac30a";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/phar-utils/zipball/7009b5139491975ef6486545a39f3e6dad5ac30a;
          sha256 = "02hwq5j88sqnj19ya9k0bxh1nslpkgf5n50vsmyjgnsi9xlkf75j";
        };
      };
    };
    "squizlabs/php_codesniffer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "squizlabs-php_codesniffer-65b12cdeaaa6cd276d4c3033a95b9b88b12701e7";
        src = fetchurl {
          url = https://api.github.com/repos/squizlabs/PHP_CodeSniffer/zipball/65b12cdeaaa6cd276d4c3033a95b9b88b12701e7;
          sha256 = "0gkm7d9ijkckkz89b1539p43ng4f98zwbmipzjs9yiwgn0mgl825";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-ce8743441da64c41e2a667b8eb66070444ed911e";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/ce8743441da64c41e2a667b8eb66070444ed911e;
          sha256 = "0s17v8jxznjccjlmmbrdk1qv9w0974102v0bbgp204rz2l228frn";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-75ad33d9b6f25325ebc396d68ad86fd74bcfbb06";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/75ad33d9b6f25325ebc396d68ad86fd74bcfbb06;
          sha256 = "0a455fbfs5nmqaivq8kpyw2maws8y9my7znq9nqv4jiy71a38zkr";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-956b8b6e4c52186695f592286414601abfcec284";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/var-dumper/zipball/956b8b6e4c52186695f592286414601abfcec284;
          sha256 = "1ihg931di160jf3v6sfrpvafa9x3g27z2h7nqz6z56l4jx4z5phf";
        };
      };
    };
    "theseer/tokenizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "theseer-tokenizer-11336f6f84e16a720dae9d8e6ed5019efa85a0f9";
        src = fetchurl {
          url = https://api.github.com/repos/theseer/tokenizer/zipball/11336f6f84e16a720dae9d8e6ed5019efa85a0f9;
          sha256 = "1nnym5d45fanxfp18yb0ylpwcvg3973ppzc67ana02g9w72gfspl";
        };
      };
    };
    "twig/twig" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-twig-e587180584c3d2d6cb864a0454e777bb6dcb6152";
        src = fetchurl {
          url = https://api.github.com/repos/twigphp/Twig/zipball/e587180584c3d2d6cb864a0454e777bb6dcb6152;
          sha256 = "0mk4xj19y8rzlghwvapr7kw4f3hjcc53g3hsz8h83vd9ncwninnf";
        };
      };
    };
    "umpirsky/twig-php-function" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "umpirsky-twig-php-function-53b4b1eb0c5eacbd7d66c504b7d809c79b4bedbc";
        src = fetchurl {
          url = https://api.github.com/repos/umpirsky/twig-php-function/zipball/53b4b1eb0c5eacbd7d66c504b7d809c79b4bedbc;
          sha256 = "1g67xb8ci20wy023wi2q87sr9msv2jvkfpliqvv0ikjgjy315gzy";
        };
      };
    };
    "wyrihaximus/twig-view" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "wyrihaximus-twig-view-a5ec66690aa045d6eda17ab1c8a5baf0efdcfa45";
        src = fetchurl {
          url = https://api.github.com/repos/WyriHaximus/TwigView/zipball/a5ec66690aa045d6eda17ab1c8a5baf0efdcfa45;
          sha256 = "0bq9mc0wsk8yj1hw54gqk8y43bq1j9nmimy7q5616zvqbdgzqrcb";
        };
      };
    };
  };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "cakephp-app";
  src = ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    homepage = https://cakephp.org;
    license = "MIT";
  };
}