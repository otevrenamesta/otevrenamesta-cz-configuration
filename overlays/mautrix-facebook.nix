self: super:
{
  python3 = super.python3.override {
    packageOverrides = python-self: python-super: {
      fbchat-asyncio = python-self.callPackage ../packages/fbchat-asyncio { };

      # can be removed when nixpkgs has recent enough version
      mautrix = python-self.callPackage ../packages/mautrix { };
    };
  };

  mautrix-facebook = self.python3Packages.callPackage ../packages/mautrix-facebook { };
}
