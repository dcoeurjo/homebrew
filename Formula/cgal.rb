class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage "http://www.cgal.org/"
  url "https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.8/CGAL-4.8.tar.xz"
  sha256 "2483ccf34ae41e830a3e33f2f471aadecf43316fb56bf632e403765ad035ce25"

  bottle do
    cellar :any
    sha256 "10d807979225870180b7a77a54923e451dce8bd0b0fc5bacdd1a3c074769045d" => :el_capitan
    sha256 "c23e7870b3b9d8f152f2a2cf39df0a399b3fd419e2bd0c246768722dcfc31ad5" => :yosemite
    sha256 "ba56ab4ee49f038a1cadf7dd8e3c03b0ecd1cd1a531d608ae360adfb03d0410a" => :mavericks
  end

  option :cxx11

  deprecated_option "imaging" => "with-imaging"

  option "with-imaging", "Build ImageIO and QT compoments of CGAL"
  option "with-eigen3", "Build with Eigen3 support"
  option "with-lapack", "Build with LAPACK support"

  depends_on "cmake" => :build
  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "gmp"   => "c++11"
  else
    depends_on "boost"
    depends_on "gmp"
  end
  depends_on "mpfr"

  depends_on "qt" if build.with? "imaging"
  depends_on "eigen" if build.with? "eigen3"

  def install
    ENV.cxx11 if build.cxx11?
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib",
           ]
    if build.without? "imaging"
      args << "-DWITH_CGAL_Qt3=OFF" << "-DWITH_CGAL_Qt4=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    end
    if build.with? "eigen3"
      args << "-DWITH_Eigen3=ON"
    end
    if build.with? "lapack"
      args << "-DWITH_LAPACK=ON"
    end
    args << "."
    system "cmake", *args
    system "make", "install"
  end
end
