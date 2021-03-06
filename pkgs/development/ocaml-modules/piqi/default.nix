{ stdenv, fetchurl, ocaml, findlib, which, ulex, easy-format, ocaml_optcomp, xmlm, base64 }:

stdenv.mkDerivation rec {
  version = "0.6.13";
  name    = "piqi-${version}";
 
  src = fetchurl {
    url = "https://github.com/alavrik/piqi/archive/v${version}.tar.gz";
    sha256 = "1whqr2bb3gds2zmrzqnv8vqka9928w4lx6mi6g244kmbwb2h8d8l";
  };

  buildInputs = [ ocaml findlib which ocaml_optcomp ];
  propagatedBuildInputs = [ulex xmlm easy-format base64];

  patches = [ ./no-ocamlpath-override.patch ./safe-string.patch ];

  createFindlibDestdir = true;

  buildPhase = ''
    make
    make -C piqilib piqilib.cma
  '';

  installPhase = ''
    make install;
    make ocaml-install;
  '';

  meta = with stdenv.lib; {
    homepage = http://piqi.org;
    description = "Universal schema language and a collection of tools built around it";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}
