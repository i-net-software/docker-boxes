# Maintainer: i-net /// software <tools@inetsoftware.de>
pkgname=tesseract-git
_sha=$SHA
pkgrel=$PKGREL
pkgver=$PKGVER

pkgdesc="Tesseract Open Source OCR Engine"
url="https://github.com/tesseract-ocr/tesseract"
arch="all"
license="Apache-2.0"
depends="leptonica"
makedepends="cmake leptonica-dev tiff-dev icu-dev cairo-dev automake autoconf libtool autoconf-archive pango-dev"
install=""
replaces="tesseract-ocr"
subpackages="$pkgname-dev $pkgname-training"
source="tesseract-$pkgver.tar.gz::https://github.com/tesseract-ocr/tesseract/archive/$_sha.tar.gz"
builddir="$srcdir/tesseract-$_sha"

prepare() {
    local i
    cd "$builddir"
    # Patches can be added for a specific build version using a unified *.<version>.patch file
    # in the root parallel to this file
    msg "Loading patches from: $startdir"
    for i in `ls $startdir/*.patch`; do
        case $i in
            *.$pkgver.patch)
                msg "$i"
                patch -p1 -i "$i" || return 1
                ;;
        esac
    done
    msg "Done patching ..."
}

build() {
        cd "$builddir"
        ./autogen.sh
        ./configure $ADDITIONAL_OPTIONS \
                --build=$CBUILD \
                --host=$CHOST \
                --prefix=/usr \
                --sysconfdir=/etc \
                --mandir=/usr/share/man \
                --infodir=/usr/share/info \
                --localstatedir=/var \
                --disable-static

        make
        make training
}

package() {
    cd "$builddir"
    make DESTDIR="$pkgdir" install
}

training() {
    cd "$builddir"
    make DESTDIR="$subpkgdir" training-install
}
