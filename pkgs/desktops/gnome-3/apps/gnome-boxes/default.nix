{ stdenv, fetchurl, meson, ninja, wrapGAppsHook, pkgconfig, gettext, itstool, libvirt-glib
, glib, gobjectIntrospection, libxml2, gtk3, gtk-vnc, libvirt, spice-gtk
, spice-protocol, libsoup, libosinfo, systemd, tracker, tracker-miners, vala
, libcap, yajl, gmp, gdbm, cyrus_sasl, gnome3, librsvg, desktop-file-utils
, mtools, cdrkit, libcdio, libusb, libarchive, acl, libgudev, qemu, libsecret
, libcap_ng, numactl, xen, libapparmor, json-glib, webkitgtk
}:

# TODO: ovirt (optional)

let
  version = "3.28.5";
in stdenv.mkDerivation rec {
  name = "gnome-boxes-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-boxes/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1z1qimspx1nw7l79rardxcx2bydj9nmk60vsdb611xzlqa3hkppm";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson ninja vala pkgconfig gettext itstool wrapGAppsHook gobjectIntrospection desktop-file-utils
  ];

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = [ spice-gtk ];

  buildInputs = [
    libvirt-glib glib gtk3 gtk-vnc libxml2
    libvirt spice-gtk spice-protocol libsoup json-glib webkitgtk libosinfo systemd
    tracker tracker-miners libcap yajl gmp gdbm cyrus_sasl libusb libarchive
    gnome3.defaultIconTheme librsvg acl libgudev libsecret
    libcap_ng numactl xen libapparmor
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${stdenv.lib.makeBinPath [ mtools cdrkit libcdio qemu ]}")
  '';

  mesonFlags = [
    "-Dovirt=false"
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-boxes";
      attrPath = "gnome3.gnome-boxes";
    };
  };

  meta = with stdenv.lib; {
    description = "Simple GNOME 3 application to access remote or virtual systems";
    homepage = https://wiki.gnome.org/action/show/Apps/Boxes;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
