#!/usr/bin/perl -w
use strict ;
use warnings ;
    
use Compress::Zlib ;
use Text::CSV_XS;
    
die "Usage: gzgrep prtline [file...]\n"
unless @ARGV >= 1;
    
my $prtline = shift ;
    
# use stdin if no files supplied
@ARGV = '-' unless @ARGV ;
    
foreach my $file (@ARGV) {
   
        print "Creating tsv object \n";
        my $tsv = Text::CSV_XS->new( { sep_char => "\t", binary => 1, eol => $/ } );
        print "tsv object created \n";

        print "opening gzipped file \n";
        my $gz = gzopen( "$file", "rb" )
          or die "Cannot open $file: $gzerrno\n";
        print "gzipped file open \n";

        my $line;
        print "looping through gzip lines \n";
        my @fields = (qw (computerId nativId softwareName softwareVersion acqTime ));
        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);
            my $index = 0;
            my %rec   = map { $fields[ $index++ ] => $_ } $tsv->fields();
            print " $line \n";     
        }
        die "Error reading from $file: $gzerrno" . ( $gzerrno + 0 ) . "\n"
          if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
}
1;
