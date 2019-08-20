{ stdenv
, fetchurl
, fetchpatch
, boost
, cmake
, doxygen
, eigen
, numpy
, pkgconfig
, pytest
, pytest_3 # remove once packages all work with pytest 4
, pythonPackages
, six
, sympy
, gtest ? null
, hdf5 ? null
, mpi ? null
, ply ? null
, python ? null
, sphinx ? null
, suitesparse ? null
, swig ? null
, vtk ? null
, zlib ? null
, docs ? false
, pythonBindings ? false
, doCheck ? true }:

assert pythonBindings -> python != null && ply != null && swig != null;

let
  version = "2019.1.0";

  dijitso = pythonPackages.buildPythonPackage {
    name = "dijitso-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/dijitso/downloads/dijitso-${version}.tar.gz";
      sha256 = "1ncgbr0bn5cvv16f13g722a0ipw6p9y6p4iasxjziwsp8kn5x97a";
    };
    buildInputs = [ numpy six ];
    checkInputs = [ pytest ];
    preCheck = ''
      export HOME=$PWD
    '';
    checkPhase = ''
      runHook preCheck
      py.test test/
      runHook postCheck
    '';
    meta = {
      description = "Distributed just-in-time shared library building";
      homepage = https://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

  fiat = pythonPackages.buildPythonPackage {
    name = "fiat-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/fiat/downloads/fiat-${version}.tar.gz";
      sha256 = "1sbi0fbr7w9g9ajr565g3njxrc3qydqjy3334vmz5xg0rd3106il";
    };
    buildInputs = [ numpy six sympy ];
    checkInputs = [ pytest_3 ];
    checkPhase = ''
      py.test test/unit/
    '';
    meta = {
      description = "Automatic generation of finite element basis functions";
      homepage = https://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

  ufl = pythonPackages.buildPythonPackage {
    name = "ufl-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/ufl/downloads/ufl-${version}.tar.gz";
      sha256 = "04daxwg4y9c51sdgvwgmlc82nn0fjw7i2vzs15ckdc7dlazmcfi1";
    };
    buildInputs = [ numpy six ];
    checkInputs = [ pytest ];
    checkPhase = ''
      py.test test/
    '';
    meta = {
      description = "A domain-specific language for finite element variational forms";
      homepage = https://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

  ffc = pythonPackages.buildPythonPackage {
    name = "ffc-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/ffc/downloads/ffc-${version}.tar.gz";
      sha256 = "1zdg6pziss4va74pd7jjl8sc3ya2gmhpypccmyd8p7c66ji23y2g";
    };
    patches = [ (fetchpatch {
      url = "https://bitbucket.org/fenics-project/ffc/commits/868b9e107944484df4f5099355bb32069289db36/raw";
      sha256 = "10achszypi3ssxa719n758pg1zq0j61b9pydlblh31lf04lzldnx";
    }) ];
    buildInputs = [ dijitso fiat numpy six sympy ufl ];
    checkInputs = [ pytest ];
    checkPhase = ''
      export HOME=$PWD
      py.test
    '';
    doCheck = false; # XXX: TODO: install ffc-factory from libs/ffc-factory
    meta = {
      description = "A compiler for finite element variational forms";
      homepage = https://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

  instant = pythonPackages.buildPythonPackage {
    name = "instant-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/instant/downloads/instant-${version}.tar.gz";
      sha256 = "1rsyh6n04w0na2zirfdcdjip8k8ikb8fc2x94fq8ylc3lpcnpx9q";
    };
    buildInputs = [ numpy six ];
    meta = {
      description = "Instant inlining of C and C++ code in Python";
      homepage = https://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

in
stdenv.mkDerivation {
  name = "dolfin-${version}";
  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/dolfin/downloads/dolfin-${version}.tar.gz";
    sha256 = "0kbyi4x5f6j4zpasch0swh0ch81w2h92rqm1nfp3ydi4a93vky33";
  };
  propagatedBuildInputs = [ dijitso fiat numpy six ufl ];
  buildInputs = [
    boost cmake dijitso doxygen eigen ffc fiat gtest hdf5 mpi
    numpy pkgconfig six sphinx suitesparse sympy ufl vtk zlib
    ] ++ stdenv.lib.optionals pythonBindings [ ply python numpy swig ];
  cmakeFlags = "-DDOLFIN_CXX_FLAGS=-std=c++11"
    + " -DDOLFIN_AUTO_DETECT_MPI=OFF"
    + " -DDOLFIN_ENABLE_CHOLMOD=" + (if suitesparse != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_DOCS=" + (if docs then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_GTEST=" + (if gtest != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_HDF5=" + (if hdf5 != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_MPI=" + (if mpi != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_PARMETIS=OFF"
    + " -DDOLFIN_ENABLE_PETSC4PY=OFF"
    + " -DDOLFIN_ENABLE_PETSC=OFF"
    + " -DDOLFIN_ENABLE_PYTHON=" + (if pythonBindings then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_SCOTCH=OFF"
    + " -DDOLFIN_ENABLE_SLEPC4PY=OFF"
    + " -DDOLFIN_ENABLE_SLEPC=OFF"
    + " -DDOLFIN_ENABLE_SPHINX=" + (if sphinx != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_TESTING=" + (if doCheck then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_TRILINOS=OFF"
    + " -DDOLFIN_ENABLE_UMFPACK=" + (if suitesparse != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_VTK=" + (if vtk != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_ZLIB=" + (if zlib != null then "ON" else "OFF");
  checkPhase = ''
    make runtests
  '';
  # TODO: install dolfin python module, wrap entry points so they can use it (dolfin-plot)
  postInstall = "source $out/share/dolfin/dolfin.conf";
  meta = {
    description = "The FEniCS Problem Solving Environment in Python and C++";
    homepage = https://fenicsproject.org/;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.lgpl3;
  };
}
