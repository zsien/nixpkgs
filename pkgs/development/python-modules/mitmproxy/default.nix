{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
  # Mitmproxy requirements
, asgiref
, blinker
, brotli
, certifi
, click
, cryptography
, flask
, h11
, h2
, hyperframe
, kaitaistruct
, ldap3
, msgpack
, passlib
, protobuf
, publicsuffix2
, pyasn1
, pyopenssl
, pyparsing
, pyperclip
, ruamel-yaml
, setuptools
, sortedcontainers
, tornado
, urwid
, wsproto
, zstandard
  # Additional check requirements
, beautifulsoup4
, glibcLocales
, hypothesis
, parver
, pytest-asyncio
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "mitmproxy";
  version = "8.0.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Efazsi8BjBrk7lBKSn2APKHxCc7mzxNrC92BL0VsnCM=";
  };

  propagatedBuildInputs = [
    setuptools
    # setup.py
    asgiref
    blinker
    brotli
    certifi
    click
    cryptography
    flask
    h11
    h2
    hyperframe
    kaitaistruct
    ldap3
    msgpack
    passlib
    protobuf
    publicsuffix2
    pyasn1
    pyopenssl
    pyparsing
    pyperclip
    ruamel-yaml
    sortedcontainers
    tornado
    urwid
    wsproto
    zstandard
  ];

  checkInputs = [
    beautifulsoup4
    glibcLocales
    hypothesis
    parver
    pytest-asyncio
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    requests
  ];

  postPatch = ''
    # remove dependency constraints
    sed 's/>=\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?\( \?, \?!=\([0-9]\.\?\)\+\)\?//' -i setup.py
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Tests require a git repository
    "test_get_version"
    # https://github.com/mitmproxy/mitmproxy/commit/36ebf11916704b3cdaf4be840eaafa66a115ac03
    # Tests require terminal
    "test_integration"
  ];

  pythonImportsCheck = [ "mitmproxy" ];

  meta = with lib; {
    description = "Man-in-the-middle proxy";
    homepage = "https://mitmproxy.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
