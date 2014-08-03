package IBM::AmTools::SchemaBase;

use strict;
use warnings;

use Carp qw{ confess };

use IBM::AmTools::Db::Config;

our $VERSION  = '0.0.1'; 
our $REVISION = '$Id: SchemaBase.pm,v 1.1 2008/09/30 23:02:06 cweyl Exp $';

sub _db_id { confess 'This function must be overridden!' }

# try to find the trails3 password; prompt if we fail
sub easy_connect {
    my $pkgname = shift @_;
    
    my $db_id = $pkgname->_db_id();
    
    # get our db connection info...
    my @dbinfo = IBM::AmTools::Db::Config
        ->instance
        ->triplet($db_id)
        ;
    
    return $pkgname->connect(@dbinfo);
}

1;

__END__

#############################################################################
#    This is the documentation AND manpage of this module.  Document it     #
#                       it well, and wisely!                                #
#############################################################################


=head1 NAME
 
IBM::AmTools::SchemaBase - another DBIC schema base class with common bits
 
 
=head1 SYNOPSIS
 
    # after the DBICSL "don't touch me!" bits
    use base 'IBM::AmTools::SchemaBase';
 
    # override to provide schema-specific IBM::AmTools::Db::Config id
    sub _db_id { 'foo' }
 
    # profit!

 
=head1 DESCRIPTION
 
This is a package defining a second base class, providing additional
functionality to our DBIC schemas.
 
 
=head1 SUBROUTINES/METHODS 
 
 
=head2 PUBLIC

=head3 easy_connect()

Automagically use the connection information accessible through
L<IBM::AmTools::Db::Config> to connect to the database.

=head2 PRIVATE

NOTE:  These methods are only documented such as they may be convienent to
override in our defined schema class.

=head3 _db_id()

Returns the key that should be used to look up the connection information via
L<IBM::AmTools::Db::Config>.
 
=head1 DIAGNOSTICS
 
A list of every error and warning message that the module can generate
(even the ones that will "never happen"), with a full explanation of each 
problem, one or more likely causes, and any suggested remedies.

 
=head1 CONFIGURATION AND ENVIRONMENT
 
A full explanation of any configuration system(s) used by the module,
including the names and locations of any configuration files, and the
meaning of any environment variables or properties that can be set. These
descriptions must also include details of any configuration language used.
 
 
=head1 DEPENDENCIES
 
A list of all the other modules that this module relies upon, including any
restrictions on versions, and an indication whether these required modules are
part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.
 
 
=head1 INCOMPATIBILITIES
 
A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for 
system or program resources, or due to internal limitations of Perl 
(for example, many modules that use source code filters are mutually 
incompatible).
 
 
=head1 BUGS AND LIMITATIONS
 
A list of known problems with the module, together with some indication
whether they are likely to be fixed in an upcoming release.
 
Also a list of restrictions on the features the module does provide: 
data types that cannot be handled, performance issues and the circumstances
in which they may arise, practical limitations on the size of data sets, 
special cases that are not (yet) handled, etc.
 
The initial template usually just has:
 
There are no known bugs in this module. 
Please report problems to Chris Weyl <cweyl@us.ibm.com>.
Patches are VERY welcome :)
 
=head1 AUTHOR
 
Chris Weyl  <cweyl@us.ibm.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2005 IBM. All rights reserved.
 
This is for IBM Internal Use ONLY.
 
$Id: SchemaBase.pm,v 1.1 2008/09/30 23:02:06 cweyl Exp $

