package IBM::Schema::TRAILS;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces(
    result_namespace => '+IBM::Schema::TRAILS',
    resultset_namespace => '+IBM::SchemaResultSet::TRAILS',
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-02 17:23:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CdN9IUmIf5gtCwDKxVlR8g

# derive version directly from CVS revision.  As good a method as any.
# our $VERSION  = (split(/ /, q$Revision: 1.16 $))[1];
our $VERSION  = '0.004004';
our $REVISION = '$Id: TRAILS.pm,v 1.16 2009/06/07 22:39:01 cweyl Exp $';

# pull in our easy_connect magic
use base 'IBM::AmTools::SchemaBase';

#sub _db_id { 'trails3' }

# override connect so we change the schema correctly
sub connect {
    my $classname = shift;
    
    my $schema = $classname->clone->connection(@_);

    # now, set default schema
    $schema->storage->dbh->do('set schema EAADMIN');

    return $schema;
}

use Moose;

with 'IBM::SchemaRoles::TRAILS';

# FIXME I'm pretty sure we're exposing these by doing this
use IBM::AmTools::Types ':all';

has cndb => (is => 'rw', lazy_build => 1, isa => CndbSchema);
sub _build_cndb { require IBM::Schema::CNDB; IBM::Schema::CNDB->easy_connect }


__PACKAGE__->meta->make_immutable(inline_constructor => 0);
no Moose;

1;
