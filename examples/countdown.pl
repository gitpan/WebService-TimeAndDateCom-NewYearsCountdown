#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(../lib lib);
use WebService::TimeAndDateCom::NewYearsCountdown;

@ARGV or die "Usage: $0 TIME_ZONE\n";
my $tz = shift;

my $hny = WebService::TimeAndDateCom::NewYearsCountdown->new;

my $data = $hny->hny( $tz )
    or die $hny->error;

printf "%s left until New Year in %s (%s, [%s])\n",
    @$data{qw/time_left  tz  countries  cities/};