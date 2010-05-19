Summary: color and style highlighting program for text
Name: clide
Version: @VERSION@
Release: 1
Copyright: GPL
Group: Utilities
Source: clide-@VERSION@.tar.gz
BuildArch: noarch
BuildRoot: /var/tmp/clide-build-@VERSION@
Packager: Mark Krenz <mark@suso.com>
Vendor: suso.com
%description
clide is a program that takes a list of search expressions tied to color
sequences to use and reformats the output so that strings that matched
are colorized in ANSI colors according to the fg and bg specified.

%prep
%setup

%build
make

%install
make ROOT="$RPM_BUILD_ROOT" rpminstall

%files
%attr(0755 root root) /usr/bin/clide
%doc %attr(- root root) CHANGELOG COPYING GOALS LICENSE README WARNING
#%attr(0755 root root) tests
%doc %attr(- root root) tests/
%{_mandir}/man1/clide.1.gz


%changelog
* Tue May 18 2010 Mark Krenz <mark@suso.com>
- 0.9 release