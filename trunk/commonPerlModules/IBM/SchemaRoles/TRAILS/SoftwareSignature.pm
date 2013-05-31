package IBM::SchemaRoles::TRAILS::SoftwareSignature;

use Moose::Role;

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.1 $))[1];
our $REVISION = '$Id: SoftwareSignature.pm,v 1.1 2008/11/11 22:48:02 cweyl Exp $';

###########################################################################
# lazy accessors 

sub id            { shift->software_signature_id        }
sub software_name { shift->software->software_name      }
sub sw_name       { shift->software->software_name      }
sub mf_name       { shift->software->manufacturer->name }
sub sw_version    { shift->software_version             }

###########################################################################
# lazy accessors 

1;

__END__

=head1 NAME

IBM::SchemaRoles::TRAILS::SoftwareSignature - Common methods and attributes

=head1 VERSION

$Id: SoftwareSignature.pm,v 1.1 2008/11/11 22:48:02 cweyl Exp $

=head1 SYNOPSIS

    # in ...BRAVO::SoftwareSignature or ...TRAILS::SoftwareSignature
    use Moose;

    # import our method/attribute definitions from this role
    with 'IBM::SchemaRoles::TRAILS::SoftwareSignature';

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

This is revision: $Id: SoftwareSignature.pm,v 1.1 2008/11/11 22:48:02 cweyl Exp $

=head1 COPYRIGHT

Copyright 2008, IBM.

For Internal Use Only!

=cut
