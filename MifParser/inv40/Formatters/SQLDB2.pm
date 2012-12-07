package MifParser::inv40::Formatters::SQLDB2;
use Class::Struct;
use strict;

struct SQLDB2 => {};

sub printLine {
    my $self = shift;
    my $sql  = shift;
    my $rc;

    return $rc;
#    if ((ref $sql) eq 'ARRAY') {
#        $rc = join "\n",@{$sql};
#    }
#    else {
#        $rc = $sql;
#    }
# 
#    return $rc;
}

sub printHeader {
   my $self = shift;
   my $sql  = shift;
   my $rc = $sql;

   return $rc;
}
    
1;
