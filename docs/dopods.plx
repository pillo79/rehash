#!/usr/bin/perl -w
use File::Copy;
use File::Spec::Functions;
for (qw(INSTALL README)) {
	print "Converting $_.pod to text\n";
	system "pod2text $_.pod > $_";
	MacPerl::SetFileInfo($ENV{EDITOR} || 'R*ch', 'TEXT', $_)
		if $^O eq 'MacOS';

	print "Converting $_.pod to HTML\n";
	system "pod2html $_.pod > $_.html";
	MacPerl::SetFileInfo($ENV{EDITOR} || 'R*ch', 'TEXT', "$_.html")
		if $^O eq 'MacOS';

	print "Copying $_ to parent directory\n";
	copy $_, catfile(updir, $_) or warn "Couldn't copy\n";
}
