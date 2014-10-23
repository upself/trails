package MifParser::inv40::Component;

use Class::Struct;
use MifParser::MifGroup;
use MifParser::inv40::Formatters::SQLDB2;
use MifParser::inv40::Formatters::SQLSyb;
use Text::ParseWords;
use strict;

struct Component => {
    group           => 'MifGroup',
    debug           => '$',
    hwsysid         => '$',
    tablePre        => '$',
};

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Footprint right now, may never use this
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub createBCP {
    my $self = shift;
    my $stats = shift;

    return $stats;
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to split a table line up
# 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub splitTableLine {
    my $self        = shift;
    my $tableLine   = shift;

    $tableLine =~ s/^\s*\{//;
    $tableLine =~ s/\}$//;
    $tableLine =~ s/\'//g;

    return quotewords(",",0,$tableLine);
}
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to figure out the correct formatter to use.  This will then 
# be applied to the SQL.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getFormat {
    my $self = shift;
    my $sqlType = shift;
    my $format;

    if ($sqlType eq "sybase") {
        $format = SQLSyb->new;
    }
    else {
        $format = SQLDB2->new;
    }

    return $format;
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to create a hash of values based on the attributes and a 
# line of data from the table section in a mif file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getHashRefSet {
    my $self = shift;
    
    my $groupRef = shift;
    my @dataList = @_;

    my $attRef          = $self->group->attributes;
    my $attributeList   = $self->group->order;
    
    my $rc;
    my $dataElement;

    # Set flag depending on table data or group data
    my $dataFlag = $groupRef->key ? 1 : 0;

    foreach my $attribute (@{$attributeList}) {

        $dataElement = $dataFlag ? (shift @dataList) :
                $groupRef->attributes->{$attribute}->value;

        if ($attRef->{$attribute}->type =~ /start enum/i) {
            $dataElement = $attRef->{$attribute}->enum($dataElement);
        }

        $rc->{$attribute}=$dataElement;
    }

    return $rc;
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to print a line of SQL data as you travers the table
# information in the mif file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub createSQLLine {
    my $self        = shift;
    return unless $self->hwsysid;

    my $sqlType     = shift;
    my $dataLine    = shift;
    my $format      = $self->getFormat($sqlType);
    my $sig         = shift;


    chomp $dataLine;

    my $qh = $self->getHashRefSet($self->group,
            $self->splitTableLine($dataLine));


    my $sqlData = $self->getStandardSQLInsert($self->tablePre,$self->hwsysid,
            $qh,$sig);

    #my $rc = $format->printLine($sqlData);


    return $sqlData;
}
1;
