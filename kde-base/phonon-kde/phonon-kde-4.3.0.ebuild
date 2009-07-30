# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="http://phonon.kde.org"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
LICENSE="GPL-2"
IUSE="alsa debug pulseaudio +xine"

DEPEND="
	media-sound/phonon[xine?]
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}
	!kdeprefix? ( !kde-base/phonon-xine[-kdeprefix] )
"

src_prepare() {
	# Don't build tests - they require OpenGL
	sed -e 's/add_subdirectory(tests)//' \
		-i phonon/CMakeLists.txt || die "Failed to disable tests"

	# Disable automagic
	sed -e 's/find_package(Xine)/macro_optional_find_package(Xine)/' \
		-i phonon/kcm/xine/CMakeLists.txt || die "Failed to make xine optional"
	sed -e "s:FIND_PACKAGE(Alsa):macro_optional_find_package(Alsa):" \
		-i phonon/CMakeLists.txt || die "Failed to make alsa optional"

	kde4-meta_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with pulseaudio PulseAudio)
		$(cmake-utils_use_with xine)"

	kde4-meta_src_configure
}
