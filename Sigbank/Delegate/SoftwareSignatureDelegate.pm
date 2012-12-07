package SoftwareSignatureDelegate;

use strict;
use Database::Connection;

sub getSoftwareSignatureMap {
    my( $self ) = @_;

    my %data;

    ###Get the trails connection
    my $trailsConnection = Database::Connection->new('trails');

    ###Prepare the query
    $trailsConnection->prepareSqlQuery( $self->querySoftwareSignature());

    ###Define the fields
    my @fields = ( qw(softwareSignatureId softwareId fileName fileSize) );

    ###Get the statement handle
    my $sth = $trailsConnection->sql->{softwareSignature};

    ###Bind the columns
    my %rec;
    $sth->bind_columns(map {\$rec{$_}} @fields);

    ###Execute the query
    $sth->execute();

    while($sth->fetchrow_arrayref) {
    	upperValues(\%rec);
        $data{$rec{fileName}}{$rec{fileSize}}{'softwareSignatureId'} = $rec{softwareSignatureId};
        $data{$rec{fileName}}{$rec{fileSize}}{'softwareId'} = $rec{softwareId};
    }

    ###Close the statement handle
    $sth->finish;

    $trailsConnection->disconnect;

    ###Return the bank account
    return \%data;
}

sub querySoftwareSignature {
    my $query = '
        select
            a.software_signature_id
            ,a.software_id
            ,a.file_name
            ,a.file_size
        from
            software_signature a
        where
            a.software_id != 1000
            and a.status = \'ACTIVE\'
    ';

    return ('softwareSignature',$query);
}
1;
