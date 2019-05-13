self: super:
{
  morph = super.morph.overrideAttrs (oldAttrs: rec {
    name = oldAttrs.name + "-sorki";
    src = super.fetchFromGitHub {
      owner = "sorki";
      repo = "morph";
      rev = "3f098a29f01bfee6f8103519c9fe9d1b02949688";
      sha256 = "0n2gxhkwrhl2aabrmqp3yqkqf2rf0ypl7pmg0qn784ca8ccmjvv6";
    };
  });
}
