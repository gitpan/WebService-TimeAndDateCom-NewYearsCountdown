#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 5;

BEGIN {
    use_ok('Carp');
    use_ok('Moo');
    use_ok('Mojo::DOM');
    use_ok('LWP::UserAgent');
    use_ok( 'WebService::TimeAndDateCom::NewYearsCountdown' ) || print "Bail out!\n";
}

diag( "Testing WebService::TimeAndDateCom::NewYearsCountdown $WebService::TimeAndDateCom::NewYearsCountdown::VERSION, Perl $], $^X" );
