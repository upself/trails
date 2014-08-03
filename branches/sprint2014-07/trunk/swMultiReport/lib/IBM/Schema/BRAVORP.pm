#############################################################################
#
# Stub IBM::Schema::BRAVO for the merged schema
#
# Author:   Chris Weyl (Global Asset Tools Team), <cweyl@us.ibm.com>
# Company:  IBM
# Created:  04/07/2009 08:39:58 PM EDT
# Revision: $Id: BRAVO.pm,v 1.10 2009/05/22 22:25:26 cweyl Exp $
#
# Detailed documentation, including the CVS commit log, can be found at the
# end of this file.
#
# Copyright (c) 2009 IBM <cweyl@us.ibm.com>
#
# This library is for IBM Internal Use only!
# 
#############################################################################

package IBM::Schema::BRAVORP;

use strict;
use warnings;

use base 'IBM::Schema::TRAILS';

our $VERSION  = $IBM::Schema::TRAILS::VERSION;
our $REVISION = '$Id: BRAVO.pm,v 1.10 2009/05/22 22:25:26 cweyl Exp $';

sub _db_id { 'trails_rp' };

1;

__END__

# $Log: BRAVO.pm,v $
# Revision 1.10  2009/05/22 22:25:26  cweyl
# - update DBIC::Schema::Loader script to correctly generate unique constraints
# - add a role, RS class and row methods to support the s/w multi report
#
# Revision 1.9  2009/04/17 17:11:37  cweyl
# - switch over to the new, unified TRAILS/BRAVO schema, and, as such:
# - drop old standalone BRAVO DBIC schema
# - add new tables to TRAILS
# - keep regen_schema_bravo from actually regenerating a schema
#

=head1 NAME

IBM::Schema::BRAVO - stub class

=head1 DESCRIPTION

IBM::Schema::BRAVO is a stub class that inherits from L<IBM::Schema::TRAILS>.
This is to ease pains in migrating from a split to a unified schema.

=head1 SEE ALSO

L<IBM::Schema::TRAILS>

=head1 AUTHOR

Chris Weyl  <cweyl@us.ibm.com>

$Id: BRAVO.pm,v 1.10 2009/05/22 22:25:26 cweyl Exp $

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 IBM. All rights reserved.

This library is for IBM Internal Use only.

=cut




