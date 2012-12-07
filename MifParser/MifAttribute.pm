package MifParser::MifAttribute;

use Class::Struct;
use Text::ParseWords;

struct MifAttribute => {
    name        => '$',
    id          => '$',
    access      => '$',
    type        => '$',
    value       => '$',
    enum        => '@',
};

sub setEnumName {
    my $self = shift;
    my $enumName = shift;

    #print "This enums name is $enumName\n";
}

sub addEnum {
    my $self = shift;
    my $enumRaw = shift;

    my ($index, $value) = quotewords('\=\s*',0,$enumRaw);
    #print "Adding value: $index --> $value\n";
    $self->enum($index,$value);
}

1;
