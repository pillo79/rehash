# This code is a part of Slash, and is released under the GPL.
# Copyright 1997-2005 by Open Source Technology Group. See README
# and COPYING for more information, or see http://slashcode.com/.

package Slash::Submit::Upgrade::MySQL;

=head1 NAME

Slash::Submit::Upgrade::MySQL


=head1 SYNOPSIS

Database upgrades file for Submit Plugin


=head1 DESCRIPTION

Automagically updates database with schema and data changes
needed for the Submit plugin when associate code changes are
made in rehash.


=head1 EXPORTED FUNCTIONS

=cut

use strict;
use Slash;
use Slash::Display;
use Slash::Utility;

use base 'Slash::Plugin';

our $VERSION = $Slash::Constants::VERSION;

sub upgradeDB() {
	my ($self, $upgrade) = @_;
	my $slashdb = getCurrentDB();
	my $schema_versions = $upgrade->getSchemaVersions();
	my $subscribe_schema_ver = $schema_versions->{db_schema_plugin_Submit};
	my $upgrades_done = 0;

	if ($subscribe_schema_ver < 1 ) {
		print "upgrading Submit to v1 ...\n";
		if(!$slashdb->sqlDo("ALTER TABLE submissions ADD COLUMN dept varchar (100) null")) {
			return 0;
		};
		if(!$slashdb->sqlDo("INSERT INTO vars (name, value, description) VALUES ('submit_dept', 0, 'Allow users to submit deptatrment with stories')")) {
			return 0;
		};
		if (!$slashdb->sqlDo("INSERT INTO site_info (name, value, description) VALUES ('db_schema_plugin_Submit', 1, 'Version of submit plugin schema')")) {
			return 0;
		};
		$subscribe_schema_ver = 1;
		$upgrades_done++;
	}

	if (!$upgrades_done) {
		print "No schema upgrades needed for Submit\n";
	}

	return 1;
}

1;
