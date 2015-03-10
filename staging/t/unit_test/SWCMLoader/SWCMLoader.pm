package t::unit_tests::SWCMLoader::SWCMLoader;

use Test::More;
use base 'Test::Class';

sub class { 'Staging::SWCMLoader' }

sub startup : Tests(startup => 1) {
    my $test = shift;
    use_ok $test->class;
}

sub constructor : Tests(2) {
     my $test  = shift;
     my $class = $test->class;
     can_ok $class, 'new';
     ok my $person = $class->new,
         '... and the constructor should succeed';
#     isa_ok $person, $class, '... and the object it returns';
}

1;
