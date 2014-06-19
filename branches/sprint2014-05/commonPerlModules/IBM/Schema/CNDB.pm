package IBM::Schema::CNDB;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_classes;


# Created by DBIx::Class::Schema::Loader v0.04003 @ 2007-12-12 17:12:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:W7lafr/hIrE946btB9qJEQ

our $VERSION= '0.1.1';

use IO::Prompt;
use File::Slurp qw{ slurp };

#use Smart::Comments '###';

our $DEFAULT_DSN  = 'dbi:DB2:CNDB';
our $DEFAULT_USER = 'cndb';

# try to find the password; prompt if we fail
sub easy_connect {

    # first, try to use I::A::D::Config...
    my $schema;
    eval {

        # just in case we can't get to it, not authed to GSA, etc
        require IBM::AmTools::Db::Config;
        
        my $c = IBM::AmTools::Db::Config->instance;

        die "no dsn entry" unless exists $c->{cndb};

        # ok, now try conencting...
        $schema = __PACKAGE__->connect(
            $c->{cndb}->{dsn},
            $c->{cndb}->{userid},
            $c->{cndb}->{passwd}
        );

        ### [<here>] we seem to have succeeded with the singleton...
    };
    return $schema if $schema;

    ### [<here>] hmm, probably not gonna work: $@

    # check this later...
    FILECHECK_LOOP:
    for my $file ( "$ENV{HOME}/.trails3.eaadmin.pwd" ) {

        ### <here> checking for: $file
        next FILECHECK_LOOP unless -r $file;

        my $passwd = slurp $file;
        chomp $passwd;
        my $schema =
            __PACKAGE__->connect($DEFAULT_DSN, $DEFAULT_USER, $passwd);

        return $schema if $schema;
    }

    # else, let's prompt for the password...
    while (1) {

        my $passwd =
            prompt "$DEFAULT_USER\@$DEFAULT_DSN password: ", -echo => '*';

        my $schema =
            __PACKAGE__->connect($DEFAULT_DSN, $DEFAULT_USER, "$passwd");

        return $schema if $schema;
    }
}


1;
