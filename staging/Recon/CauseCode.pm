package Recon::CauseCode;

use strict;
use Base::Utils;

sub updateCCtable {
	my ( $alertid, $alertcode, $connection) = @_;
	
	if ( GetByAlert ( $alertid, $alertcode, $connection ) ) {
		# alert ID + alerttype combination already found, nothing added
		return 0;
		
	} else {
		$connection->prepareSqlQuery(queryInsertCC());

		my $sth=$connection->sql->{insertCC};
		my $id;
	
		$sth->bind_columns( \$id );
		$sth->execute( $alertcode, $alertid );
		$sth->fetchrow_arrayref;
		$sth->finish;
		
		# returns ID of the row in the cause_code table
		
		return $id;

	}
}

sub GetByAlert {
	my ( $alertid, $alertcode, $connection ) = @_;
	
	$connection->prepareSqlQuery(queryGetByAlert());
	
	my $sth=$connection->sql->{GetCCbyAlert};
	my $id;
	
	$sth->bind_columns( \$id );
	$sth->execute( $alertcode, $alertid );
	$sth->fetchrow_arrayref;
	$sth->finish;
	
	return $id if ( defined $id );
	
	return 0;
}

sub queryGetByAlert {
	my $query = '
		select
			cc.id
		from
			cause_code cc join alert_type at on cc.alert_type_id = at.id
		where
			at.code = ?
			and
			cc.alert_id = ?
		with ur
		';
	return ( 'GetCCbyAlert', $query );
}



sub queryInsertCC {
    my $query = '
        select
            id
        from
            final table (
        insert into cause_code (
            alert_type_id,
            alert_id,
            alert_cause_id,
            target_date,
            owner,
            record_time,
            remote_user
        ) values (
            ( select id from alert_type where code = ? ),
            ?,
            1,
            null,
            null,
            null,
            null
        ))
    ';
    return ('insertCC', $query);
}

=pod

sub queryUpdate {
    my $query = '
        update alert_hardware
        set
            hardware_id = ?
            ,comments = ?
            ,open = ?
            ,creation_time = ?
            ,remote_user = \'STAGING\'
            ,record_time = CURRENT TIMESTAMP
        where
            id = ?
    ';
    return ('updateAlertHardware', $query);
}

=cut

1;
