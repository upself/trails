package IBM::SchemaRoles::TRAILS;

use Moose::Role;

use DateTime;

# derive version directly from CVS revision.  As good a method as any.
our $VERSION  = '0.' . (split(/ /, q$Revision: 1.5 $))[1];
our $REVISION = '$Id: TRAILS.pm,v 1.5 2009/02/20 19:49:18 cweyl Exp $';

###########################################################################
# lazy accessors 

# none atm!

###########################################################################
# for easy_connect() (which should really be refactored as a role) 

sub _db_id { 'trails3' }

###########################################################################
# Bank Account bits

# given a shortname, get a dbh to a given bankaccount
sub get_bank_account_connect_info {
    my $self    = shift @_;
    my $ba_name = shift @_;

    ### <here> trying to get dbh for: $ba_name
    my $rs = $self->resultset('BankAccount')->search({ name => uc $ba_name });

    ### assert: $rs->count() == 1
    my $ba = $rs->first;

    # construct our dsn based on the db type
    my $dsn;
    my $db_type = $ba->database_type;
    if ($db_type eq 'DB2') {

        # dbi:DB2:DATABASE=$db; HOSTNAME=$hostname; PORT=$port; 
        #   PROTOCOL=TCPIP; UID=$user; PWD=$pass;
        $dsn = "dbi:$db_type:DATABASE=" . uc $ba->database_name
            . '; HOSTNAME=' . $ba->database_ip
            . '; PORT='     . $ba->database_port
            . '; PROTOCOL=TCPIP'
            #. '; UID='      . $ba->database_user
            #. '; PWD='      . $ba->database_password
            ;
    }
    else {

        # we don't handle anything but db2 at the moment
        die "unknown db type ($dsn) for " . $ba->database_name;
    }

    # set our atts to be sane for both DBIC and plain old DBI
    my $atts = { RaiseError => 1 };
    $atts->{on_connect_do} = [ 'set schema ' . $ba->database_schema ]
        if defined $ba->database_schema;

    return ($dsn, $ba->database_user, $ba->database_password, $atts);
}

sub get_bank_account_dbh {
    my $self    = shift @_;
    my $ba_name = shift @_;

    my @info = $self->get_bank_account_connect_info($ba_name);
    
    ### <here> attempting to connect to: $dsn
    #my $dbh = DBI->connect($dsn, $ba->database_user,$ba->database_password,
    #    { RaiseError => 1 }
    #);

    my $dbh = DBI->connect(@info);

    if (not defined $dbh) {

        ## # <here> $ba
        confess "Could not connect to $ba_name";
    }

    ### <here> set schema if exists: $ba->database_schema
    #$dbh->do('set schema ' . $ba->database_schema);

    return $dbh;
}

sub new_system_schedule_status {
    my $self     = shift @_;
    my $name     = shift @_ || confess 'Must pass name!';
    #my $comments = shift @_ || 'Starting.';

    my %opts = @_;

    my $comments = $opts{comments}    ? $opts{comments}    : 'Starting.';
    my $user     = $opts{remote_user} ? $opts{remote_user} : 'STAGING'  ;

    my $rs    = $self->resultset('SystemScheduleStatus');
    my $table = $rs->result_source->from;

    #my $id = "(select max(id) + 1 from $table)";

    return $rs->update_or_create({
    
        # ARGH! non-autoincrementing PK's are EVIL.
        #id => \"(select max(id) + 1 from $table)",
        
        name        => $name,
        status      => 'PENDING',
        start_time  => DateTime->now,
        comments    => $comments,
        remote_user => $user,
    });
}

###########################################################################
# Magic! 

1;

__END__

=head1 NAME

IBM::SchemaRoles::TRAILS - Common methods and attributes

=head1 DESCRIPTION

This is a role containing the methods and attributes common to both the 
BRAVO schema ('EAADMIN') and the TRAILS3 schema ('TAP').  We centralize
them here for a number of reasons:

=over 4

=item * We don't want the TRAILS/BRAVO classes to fall out of sync.

=item * We're lazy.

=back

Laziness being a virtue here, of course.

=head1 METHODS

=head2 get_bank_account_dbh('bank account name')

Given the shortname of an account stored in the bank_account table, attempt to
connect and return the resulting $dbh.

=head2 new_system_schedule_status($name, ...)

Create a new record in the system_schedule_status table; returns the resulting
SystemScheduleStatus row object.

Optional parameters:

=over 4

=item B<comments> - any comments; defaults to 'Starting.'

=item B<remote_user> - the remote userid; defaults to 'STAGING'.

=back

=head1 AUTHOR

Chris Weyl <cweyl@us.ibm.com>

=head1 COPYRIGHT

Copyright 2008, IBM.

For Internal Use Only!

$Source: /cvs/perl/IBM-Schema-TRAILS/lib/IBM/SchemaRoles/TRAILS.pm,v $

=cut
