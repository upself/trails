package MifParser::MifGroup;

use Class::Struct;


struct MifGroup => {
    name        => '$',
    class       => '$',
    key         => '$',
    attributes  => '%',
    order       => '@',
    table       => '$',
};

sub addAttribute {
    my $self    = shift;
    my $key     = shift;
    my $value   = shift;

    $self->attributes($key,$value);
    $self->order((scalar @{$self->order}),$key);
}

1;
