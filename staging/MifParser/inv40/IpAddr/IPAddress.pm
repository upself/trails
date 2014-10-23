package MifParser::inv40::IPAddress;

use Class::Struct;
use MifParser::MifGroup;
use MifParser::inv40::Component;
use Text::ParseWords;
use strict;
use base ("MifParser::inv40::Component");

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to print the header SQL object.  In this case a delete
# Statement to cleanup data
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub createSQLHeader {
    my $self    = shift;
    return unless $self->hwsysid;

    # This method is probally not needed anymore, we will be assuming that
    # a global header is set first off the bat.  This will prevent ownership
    # at the object label.
}




#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Use this method to get the standard sql insert statement 
# 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
sub getStandardSQLInsert {

    my $self        = shift;
    my $tablePre    = shift;
    my $hwsysid     = shift;    
    return unless $hwsysid;

    my $qh          = shift;

    my $index       = $qh->{'Index'};
    my $address     = $qh->{'Address'};
    my $hostname    = $qh->{'Hostname'};
    my $domain      = $qh->{'Domain'};
    my $subnet      = $qh->{'Subnet'};
    my $gateway     = $qh->{'Gateway'};
    my $pri_dns     = $qh->{'Primary DNS'};
    my $sec_dns     = $qh->{'Seconday DNS'};

    my $rc;

    $rc->[0] = "insert into ".$tablePre."ip_addr ".
            "(computer_sys_id, ip_addr, ip_hostname, ip_domain, ip_subnet, ".
            "ip_gateway, ip_primary_dns, ip_secondary_dns) ".
            "values ("."\'".$hwsysid."\',\'".$address."\',\'".$hostname."\',\'".
            $domain."\',\'".$subnet."\',\'".$gateway."\',\'".$pri_dns."\',\'".
            $sec_dns."\')\n";


    return $rc;
}

1;
