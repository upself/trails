package IBM::SchemaRoles::TRAILS::Software;

use Moose::Role;

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.2 $))[1];
our $REVISION = '$Id: Software.pm,v 1.2 2009/01/16 02:37:32 cweyl Exp $';

###########################################################################
# lazy accessors 

sub id         { shift->software_id         }
sub name       { shift->software_name       }
sub filters    { shift->software_filters    }
sub sigs       { shift->software_signatures }
sub signatures { shift->software_signatures }
sub category   { shift->software_category   }
sub history    { shift->software_hs         }

# utilizing joins...
sub mf_name    { shift->manufacturer->name  }


1;

__END__

=head1 NAME

IBM::SchemaRoles::TRAILS::Software - Common methods and attributes

=head1 VERSION

$Id: Software.pm,v 1.2 2009/01/16 02:37:32 cweyl Exp $

=head1 SYNOPSIS

    # in ...BRAVO::Software or ...TRAILS::Software
    use Moose;

    # import our method/attribute definitions from this role
    with 'IBM::SchemaRoles::TRAILS::Software';

    # clean up
    __PACKAGE__->meta->make_immutable();
    no Moose;

=head1 DESCRIPTION

This is a role containing the methods and attributes common to this table in
both the BRAVO schema ('EAADMIN') and the TRAILS3 schema ('TAP').  We
centralize them here for a number of reasons:

=over 4

=item We don't want the TRAILS/BRAVO classes to fall out of sync.

=item We're lazy.

=back

Laziness being a virtue here, of course.

=head1 AUTHOR

Chris Weyl <cweyl@us.ibm.com>

$Id: Software.pm,v 1.2 2009/01/16 02:37:32 cweyl Exp $

=head1 COPYRIGHT

Copyright 2008, IBM.

For Internal Use Only!

=cut
