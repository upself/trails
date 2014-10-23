package MifParser::inv40::Formatters::SQLSyb;
use Class::Struct;
use strict;

struct SQLSyb => {};

sub printLine {
    my $self = shift;
    my $sql  = shift;
    my $rc;
    
    if (! $sql) {
        return;
    } 

    if ((ref $sql) eq 'ARRAY') {
        $sql = join "go\n",@{$sql};
    }

    $rc = "$sql"."go\n";

    return $rc;
}

sub printHeader {
    my $self    = shift;
    my $sql  = shift;
    my $rc .= "$sql"."go\n";

    return $rc;
}
1;
