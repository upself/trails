#!/usr/bin/perl -w

open (BANK, "<", "/home/dbryson/asset_emea/bank_data2.txt") or die "cannot open file";
open (OUTPUT, ">", "/home/dbryson/asset_emea/bank_data3.txt") or die "cannot open outputfile";

$count = 0;
$lastId = 0;
$bankText = "";
print OUTPUT "ACCOUNT NUMBER\tACCOUNT NAME\tHOST\tBANK ACCOUNT\n";

while (<BANK>) {
	chomp;
	my @fields = split /,/;
	$fields[4] =~ s/\"//g;
	if ( ! ($fields[0] eq $lastId ) ) {
		print OUTPUT $str;
		$bankText = "";
	}
	if ( ! $bankText eq "" ) {
		$bankText = "$bankText," . $fields[4];
	} else {
		$bankText = $fields[4];
	} 
	$str = $fields[1] . "\t" . $fields[2] . "\t" .  $fields[3] . "\t" . "\"" . $bankText . "\"\n";
	$lastId = $fields[0];
	$count = $count + 1;
}
close (BANK);
close (OUTPUT);
