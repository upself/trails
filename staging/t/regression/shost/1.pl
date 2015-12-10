    use WWW::Mechanize;
    my $mech = WWW::Mechanize->new();

	my $url = 'http://tapmf.boulder.ibm.com:8666/shost'
    $mech->get( $url );

    $mech->follow_link( n => 3 );
    $mech->follow_link( text_regex => qr/download this/i );
    $mech->follow_link( url => 'http://host.com/index.html' );

    $mech->submit_form(
        form_number => 3,
        fields      => {
            username    => 'mungo',
            password    => 'lost-and-alone',
        }
    );

    $mech->submit_form(
        form_name => 'search',
        fields    => { query  => 'pot of gold', },
        button    => 'Search Now'
    );