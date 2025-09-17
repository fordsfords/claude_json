#!/usr/bin/env perl
# x.pl

use strict;
use warnings;
use Getopt::Std;
use File::Basename;
use Carp;

# globals
my $tool = basename($0);

# process options.
use vars qw($opt_h $opt_o);
getopts('ho:') || mycroak("getopts failure");

if (defined($opt_h)) {
  help();
}

my $out_fd;
if (defined($opt_o)) {
  open($out_fd, ">", $opt_o) or mycroak("Error opening '$opt_o': $!");
} else {
  $out_fd = *STDOUT;
}

my $uuid = "";
my $title = "";
my %empty_msgs;
my %full_msgs;

# Main loop; read each line in each file.
while (<>) {
  chomp;  # remove trailing \n
  s/\\"/'/g;  # fix double quotes.

  # do rest of work.
  if (/^  \{/) {
    $uuid = "";
    $title = "";
  }
  elsif (/^  \}/) {
    print "uuid=$uuid, title='$title', full=$full_msgs{$uuid}, empty=$empty_msgs{$uuid}\n";
  }
  elsif (/^    "uuid": "([^"]+)"/) {
    $uuid = $1;
    $full_msgs{$uuid} = 0;
    $empty_msgs{$uuid} = 0;
  }
  elsif (/^    "name": ""/) {
    $title = "";
  }
  elsif (/^    "name": "([^"]+)"/) {
    $title = $1;
  }
  elsif (/^        "text": ""/) {
    $empty_msgs{$uuid}++;
  }
  elsif (/^        "text": "([^"]+)"/) {
    $full_msgs{$uuid}++;
  }
} continue {  # This continue clause makes "$." give line number within file.
  close ARGV if eof;
}

# All done.
exit(0);


# End of main program, start subroutines.


sub mycroak {
  my ($msg) = @_;

  if (defined($ARGV)) {
    # Print input file name and line number.
    croak("Error (use -h for help): input_file:line=$ARGV:$., $msg");
  } else {
    croak("Error (use -h for help): $msg");
  }
}  # mycroak


sub assrt {
  my ($assertion, $msg) = @_;

  if (! ($assertion)) {
    if (defined($msg)) {
      mycroak("Assertion failed, $msg");
    } else {
      mycroak("Assertion failed");
    }
  }
}  # assrt


sub help {
  my($err_str) = @_;

  if (defined $err_str) {
    print "$tool: $err_str\n\n";
  }
  print <<__EOF__;
Usage: $tool [-h] [-o out_file] [file ...]
Where ('R' indicates required option):
    -h - help
    -o out_file - output file (default: STDOUT).
    file ... - zero or more input files.  If omitted, inputs from stdin.

__EOF__

  exit(0);
}  # help
