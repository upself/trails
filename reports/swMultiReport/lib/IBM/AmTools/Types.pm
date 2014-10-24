#############################################################################
#
# Various common Moose types for our schemas, etc.
#
# Author:   Chris Weyl (Global Asset Tools Team), <cweyl@us.ibm.com>
# Company:  IBM
# Created:  04/02/2009 06:28:18 PM EDT
# Revision: $Id: Types.pm,v 1.1 2009/04/03 00:24:21 cweyl Exp $
#
# Detailed documentation, including the CVS commit log, can be found at the
# end of this file.
#
# Copyright (c) 2009 IBM <cweyl@us.ibm.com>
#
# This library is for IBM Internal Use only!
# 
#############################################################################

package IBM::AmTools::Types;

use strict;
use warnings;

#use English qw{ -no_match_vars };  # Avoids regex performance penalty

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.1 $))[1];
our $REVISION = '$Id: Types.pm,v 1.1 2009/04/03 00:24:21 cweyl Exp $';

use MooseX::Types::Moose ':all';

use namespace::clean -except => 'meta';

use MooseX::Types -declare => [ qw{
    
    BravoSchema
    TrailsSchema
    SoftReqSchema
    SwcmSchema
    ReportingSchema
    CndbSchema
} ];

subtype BravoSchema,
    as Object,
    where   { $_->isa('IBM::Schema::Bravo')   },
    message { 'Object isa IBM::Schema::Bravo' },
    ;
    
subtype TrailsSchema,
    as Object,
    where   { $_->isa('IBM::Schema::Trails')   },
    message { 'Object isa IBM::Schema::Trails' },
    ;
    
subtype SoftReqSchema,
    as Object,
    where   { $_->isa('IBM::Schema::SoftReq')   },
    message { 'Object isa IBM::Schema::SoftReq' },
    ;

subtype SwcmSchema,
    as Object,
    where   { $_->isa('IBM::Schema::SWCM')   },
    message { 'Object isa IBM::Schema::SWCM' },
    ;

subtype ReportingSchema,
    as Object,
    where   { $_->isa('IBM::Schema::Reporting')   },
    message { 'Object isa IBM::Schema::Reporting' },
    ;

subtype CndbSchema,
    as Object,
    where   { $_->isa('IBM::Schema::CNDB')   },
    message { 'Object isa IBM::Schema::CNDB' },
    ;


1;

__END__

# $Log: Types.pm,v $
# Revision 1.1  2009/04/03 00:24:21  cweyl
# - add proxy support
# - add Moose types for our schemas (+ a load test)
#

=head1 NAME

IBM::AmTools::Types - various Moose types for AmTools classes

=head1 SYNOPSIS

    use Moose;
	use IBM::AmTools::Types ':all';

    # ...

    has cndb => (is => 'ro', isa => CndbSchema, lazy_build => 1);
    sub _build_cndb { require IBM::Schema::CNDB; IBM::Schema::CNDB->new }
    
=head1 DESCRIPTION

This module provides a number of L<Moose> types for use with the AmTools
schemas, etc.  Moose has a powerful and easy to use type system...  However,
for direct class checking (e.g. "isa => 'IBM::X::Y'") there is a requirement 
that the classes be loaded; normally this isn't a problem but some schemas are
LARGE.  Really, really large.  And for command-line apps that may or may not
need this schema, this is painful.

These types allow one to continue using the Moose typing system while making
it possible to delay the loading of these schemas until they're actually
needed.

=head1 TYPES

We define the following types... Note that at this point, no coercions are
defined.

=over

=item B<SchemaTrails> - L<IBM::Schema::>

=item B<SchemaBravo> - L<IBM::Schema::>

=item B<SchemaSwcm> - L<IBM::Schema::>

=item B<SchemaSoftReq> - L<IBM::Schema::>

=item B<SchemaReporting> - L<IBM::Schema::>

=item B<SchemaCndb> - L<IBM::Schema::>

=back

=head1 SEE ALSO

L<MooseX::Types>, L<Moose::Types>

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Chris Weyl <cweyl@us.ibm.com>.

Patches are welcome.

=head1 AUTHOR

Chris Weyl  <cweyl@us.ibm.com>

$Id: Types.pm,v 1.1 2009/04/03 00:24:21 cweyl Exp $

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 IBM. All rights reserved.

This library is for IBM Internal Use only.

=cut

