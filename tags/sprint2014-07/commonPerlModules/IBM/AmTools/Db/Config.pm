#############################################################################
#
# Get easy access do DB connection information 
#
# Author:   Chris Weyl (Global Asset Tools Team), <cweyl@us.ibm.com>
# Company:  IBM
# Created:  02/05/2009 11:30:43 AM PST
# Revision: $Id: Config.pm,v 1.7 2009/04/03 00:24:21 cweyl Exp $
#
# Detailed documentation, including the CVS commit log, can be found at the
# end of this file.
#
# Copyright (c) 2007-2009 IBM <cweyl@us.ibm.com>
#
# This library is for IBM Internal Use only!
# 
#############################################################################

package IBM::AmTools::Db::Config;

use base 'Config::Tiny::Singleton';

use warnings;
use strict;

our $VERSION = '0.06';

use filetest 'access';

# find the right file
my $filename = -r '/opt/common/utils/dbs.ini'
             ? '/opt/common/utils/dbs.ini'
             : '/gsa/pokgsa/projects/a/am-reporting/admin/dbs.ini'
             ;

__PACKAGE__->file($filename);

# primitive dbiproxy support here
sub _dbi_proxy {
    my ($self, $dsn) = @_;

    if ($ENV{AMTOOLS_DBIPROXY_HOST} && $ENV{AMTOOLS_DBIPROXY_PORT}) {

        ### rejigger our DSN to use a proxy...
        $dsn = "dbi:Proxy:hostname=$ENV{AMTOOLS_DBIPROXY_HOST};"
             . "port=$ENV{AMTOOLS_DBIPROXY_PORT};"
             . "stderr=1;dsn=$dsn"
             ;
    }

    return $dsn;
}

# let's see if we can make things easier here...
sub triplet {
    my $self = shift @_;
    my $db   = lc shift @_ || die "must pass db key";

    #my $instance = __PACKAGE__->instance;
    return (
        # use a proxied DSN if
        $self->_dbi_proxy($self->{$db}->{dsn}),
        $self->{$db}->{userid},
        $self->{$db}->{passwd},
    );
}

1;

__END__

#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::AmTools::Db::Config -- get db connection info from dbs.ini
 
 
=head1 VERSION
 
This documentation refers to IBM::AmTools::Db::Config version 0.0.1.
 
 
=head1 SYNOPSIS
 
    use IBM::AmTools::Db::Config;
    my $c = IBM::AmTools::Db::Config->instance;
 
    # if just using the DBI
    my $dbh = DBI->connect($c->triplet('trails3'));
  
    # if using one of the DBIx::Class schemas
    use IBM::Schema::CNDB;
    my $cndb = IBM::Schema::CNDB->connect($c->triplet('trails3'));


=head1 DESCRIPTION
 
This is a singleton class which reads a .ini file containing database
connection information (dsn, userid, password) out of GSA...  This information
can then be passed to the DBI to connect to the db.
 
 
=head1 SUBROUTINES/METHODS 
 
This package has only one public method:


=head2 triplet

Passed the name of a database, returns an array of the dsn, userid and
password that should be used to connect to the db.  This array is suitable to
pass directly to DBI->connect.
 
Will die if not passed the name of a db.  (Case doesn't matter.)
 
=head1 DIAGNOSTICS
 
triplet() will die if not passed a db name, or will return undef if the passed
db name doesn't correspond to any known db.

 
=head1 CONFIGURATION AND ENVIRONMENT
 
GSA access to the pokgsa cell must be configured (either automount or
manually), as the ini file is accessed over a NFS mount.
 
=head1 DEPENDENCIES
 
You must be logged into GSA using a userid capable of accessing:

    /gsa/pokgsa/projects/a/am-reporting/admin/

If you can 'ls' it, you're probably ok :)
 
 
=head1 INCOMPATIBILITIES
 
None known.
 
 
=head1 BUGS AND LIMITATIONS
 
There are no known bugs in this module. 

Please report problems to Chris Weyl <cweyl@us.ibm.com>.

Patches are VERY welcome :)


=head1 AUTHOR
 
Chris Weyl  <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2005 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 

