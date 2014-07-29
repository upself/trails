package IBM::Schema::SWCM;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_classes;


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-27 14:56:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:t0mhroWx2oGCJoUgq2mhjQ

our $VERSION = '0.02';

use base 'IBM::AmTools::SchemaBase';

sub _db_id { 'swcmprod' }

# override connect so we change the schema correctly
sub connect {
    my $classname = shift;

    # get a connected instance and set the schema
    my $schema = $classname->clone->connection(@_);
    $schema->storage->dbh->do('set schema SWLM');

    return $schema;
}
                    

1;

__END__
