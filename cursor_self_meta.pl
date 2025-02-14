#!/usr/bin/perl -w

our $VERSION='0.20250114';	# Please use format: major_revision.YYYYMMDD[hh24mi]

=head1 cursor_self_meta

Easy solution to:

=over 4

=item *

Let the cursor_ide have programatic access to it's own chat and composer histories

=back


=head2 Options

	-debug		# print everything going on


=head2 Linux

	Works natively

=head2 Windows

	If this code is run inside Windows, it may re-launch itself inside WSL to do its work.

=head2 Mac

	Not tested

=cut
######################################################################

use bytes;		# don't break UTF8
use strict;
use warnings;		# same as -w switch above

use Getopt::Long;	# Commandline argument parsing
require Cwd;
Cwd->import() unless(defined &main::getcwd);  # Manually call import() to load functions like getcwd (which other modules might have done before; getcwd is not well behaved)

my $is_tty_out = (!-f STDOUT) && ( -t STDOUT && -c STDOUT);	# -f is a file, -t is a terminal, -c is a character device
my ($norm,$red,$grn,$yel,$nav,$blu,$save,$rest,$clr,$prp,$wht)=!$is_tty_out ? ('','','','','','','','','','','') : ("\033[0m","\033[31;1m","\033[32;1m","\033[33;1m","\033[34;1m","\033[36;1m","\033[s","\033[u","\033[K","\033[35;1m","\033[37;1m"); # so we can print colour output if we want.
my(@oriargs)=@ARGV;

my %arg;&GetOptions('help|?'	=> \$arg{help},			# breif instructions
		    'c=s'	=> \$arg{c},			# "cd" into this folder first
		    'debug'	=> \$arg{debug},
	   ) or &pod2usage(2); 
no warnings;
	   &pod2usage(1) if ($arg{help});			# exits
use warnings;

$arg{c}=1 unless($arg{c});

sub d2l { # Convert a DOS/Windows filespec to a Linux one
  #my($dospath)=@_;			# C:\Users\cnd\Downloads\mygit.pl
  $_[0]=~s/\\/\//g;              	# C:/Users/cnd/Downloads/mygit.pl
  $_[0]=~s/^(\w):/\L\/mnt\/$1/;	# /mnt/c/Users/cnd/Downloads/mygit.pl
  $_[0]=~s/'/'"'"'/g;		# handle Folder's insanity (gets wrapped in 'apos' later you see...)
  $_[0]=~s/\$/\\\\\\\$/g;		# Windows requires 3 \ in front of all $ to stop bash interpreting them
  return $_[0]; # now a WSL linux path :-)
} # d2l
sub chompnl {# chomp() on unix doesn't eat "\r"...
  chop $_[0] while((substr($_[0],-1) eq "\015")||(substr($_[0],-1) eq "\012"));
} # chompnl

sub shellsafe { # make filenames with ugly's spaces and mess! work inside bash 'apos'
  my($fn)=@_;
  &chompnl($fn);
  $fn=~s/([\$\#\&\*\?\;\|\>\<\(\)\{\}\[\]\"\'\~\!\\\s])/\\$1/g;
  return $fn;
} # shellsafe
sub pod2usage { # standard perls do not always have access to Pod::Usage
  my($ec)=@_;
  if($ec) {
    my $in_pod = 0;
    open my $fh, '<', $0 or die "Can't open file: $!";  # Open the script itself
    while (<$fh>) {
      last if /^__END__/;
      $in_pod = 1 if (/^=(pod|head\d|over|item|back|begin|for|end)/);
      print if $in_pod;
      $in_pod = 0 if (/^=cut/);
    }
    close $fh;
  } # #1
  #print "$ec: $!";
  exit($_[0]);
} # pod2usage


die "infinte recursive loop detected: $^O $0 " . getcwd() . " c=$arg{c}" if($arg{c}>3); # prevent loop


if($^O eq 'MSWin32') { # Make this code work on windows too (if WSL exists)
  my $pwd =&d2l( getcwd() );
  my $pgm=&d2l($0);
  my @ac=@oriargs; # @ARGV;
  foreach (@ac) { &d2l($_) if /^(\w):/ }
  
  print "Re-running '$pgm' in folder '$pwd' under WSL (this code is not compatible with $^O)\n";

  my @lnxarg=('C:\Windows\system32\wsl.exe','-e','perl',$pgm);
  push @lnxarg,@ac;

  my $rc=system( @lnxarg );
  my $ec=$?>>8;
  print "Ran. rc=$rc ec=$ec\n";
  exit(0);
} else {
  print "Running '$0' under $^O in folder: ".`pwd`;
}

print "$$ Hello World\n";

