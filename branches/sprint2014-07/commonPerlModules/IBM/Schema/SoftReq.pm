package IBM::Schema::SoftReq;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces(
    result_namespace => '+IBM::Schema::SoftReq',
    resultset_namespace => '+IBM::SchemaResultSet::SoftReq',
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-08-27 13:48:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aZcWykgxzA8TjJPc1XaHCg

use base 'IBM::AmTools::SchemaBase';

use Moose;

use IBM::AmTools::Types ':all';

our $VERSION = '2.19';

###########################################################################
# helper definitions 

use Sys::Hostname;

# connect via localhost on tapreports; else the full hostname.  We do this so
# we connect via the (faster) local socket when actually on tapreports.
our $REPORTING_HOST 
    = hostname eq 'tapreports'
    ? 'localhost'
    : 'tapreports.pok.ibm.com'
    ;

###########################################################################
# helper subs 

# connect to reporting.  makes life easier :)
sub connect_to_reporting {

    return __PACKAGE__->connect(
        # mysql_compression=1 <-- ???
        "DBI:mysql:database=softreq;host=$REPORTING_HOST",
        'reporting',
        'vi3wonly'
    );                
}
    
sub _db_id { 'softreq' }

has cndb  => (is => 'rw', isa => CndbSchema, lazy_build => 1);
has swcm  => (is => 'rw', isa => SwcmSchema, lazy_build => 1);
has bravo => (is => 'rw', isa => BravoSchema, lazy_build => 1);

sub _build_cndb  { require IBM::Schema::CNDB; IBM::Schema::CNDB->easy_connect }
sub _build_swcm  { require IBM::Schema::SWCM; IBM::Schema::SWCM->easy_connect }
sub _build_bravo { require IBM::Schema::BRAVO; IBM::Schema::BRAVO->easy_connect }

has cndb_customer_rs => (
    is   => 'ro',
    isa  => 'DBIx::Class::ResultSet',
    lazy => 1,

    #default
    builder => '_build_cndb_customer',
);
sub _build_cndb_customer {
    my $self = shift;

    return $self
        ->cndb
        ->resultset('Customer')
        ->search(undef, { cache => 1, prefetch => 'customer_type' })
        ;
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
no Moose;

1;

__END__

#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::Schema::SoftReq - DBIx::Class schema to access SoftReq
 
 
=head1 SYNOPSIS
 
    use IBM::Schema::SoftReq ;
 
    # we only have a reporting instance right now, so use this
    my $sreq = IBM::Schema::SoftReq->connect_to_reporting();
  
    # ...
    
    # we can also use easy_connect(), which just calls the former right now
    my $sreq = IBM::Schema::SoftReq->easy_connect()
  
    # profit!
  
  
=head1 DESCRIPTION
 
IBM::Schema::SoftReq is a DBIx::Class schema to the SoftReq RDBMS.
 

=head1 TABLES

This schema has the following tables (resultsets) defined.  For more
information on any of them, please see their perldoc.

    * IBM::Schema::SoftReq::MainRequest 
    * IBM::Schema::SoftReq::SoftwareRequest
    * IBM::Schema::SoftReq::AdhocProfiles
    * IBM::Schema::SoftReq::DeletedNotes
    * IBM::Schema::SoftReq::Meta
 
=head1 METHODS 
 
This class only has two additional methods beyond those provided in
DBIx::Class.

=head2 connect_to_reporting()

There is only a reporting instance -- this connects you to it, in a read only
fashion. 
 
=head2 easy_connect()

Use IBM::AmTools::Db::Config to attempt to connect to the database.

=head2 cndb()

More properly an attribute, this contains a live IBM::Schema::CNDB connection.
Note the connection is constructed the first time you attempt to access it.

=head2 cndb_customer()

Returns a IBM::Schema::CNDB::Customer resultset object, with caching enabled.
This should be much faster than 5000 individual queries for the same row of
the customer table :-)

=head1 DIAGNOSTICS
 
See DBIx::Class for more information.


=head1 CONFIGURATION AND ENVIRONMENT
 
You are using this on a system that has a properly configured mysql client,
right? :) 


=head1 DEPENDENCIES
 
Right now, SoftReq data is stored in MySQL....  As such, DBD::MySQL is
required to connect.

Note that while we will likely migrate to DB2 in the future (after intense,
active development of this db has settled down), this will not impact any
programs written using this schema; as long as no mysql-specific SQL code is
injected.  (Which, really, you'd have to put some effort into.)

 
=head1 INCOMPATIBILITIES
 
None known.

 
=head1 BUGS AND LIMITATIONS
 
There are no known bugs in this module; the documentation however is a touch
lacking at the moment. 

Please report problems to Chris Weyl <cweyl@us.ibm.com>.

Patches are VERY welcome :)


=head1 AUTHOR
 
Chris Weyl  <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2007, 2008 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 

