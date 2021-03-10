#!/usr/bin/perl
#
# re-format index.html from how igal created to how I want it.
my $date=`date +%d" "%b" "%Y`;
chomp ($date);
#print "date: $date \n";
open (FILE, "< index.html") || die;
while (<FILE>) {
	# dump tabs
	if (/nbsp/) {
		next;
	}
	# add pix class
	s/\<td\ bgcolor=\"#000000\"\ valign=middle\ align=center\>/\<TD\ class=\"pix\"\>/g; 
	# center table elements
	s/table\ border=0/TABLE\ align=\"center\"\ border=0/g; 
	# add current date
	s/DATE/$date/g;
	print;
}
exit 0;
