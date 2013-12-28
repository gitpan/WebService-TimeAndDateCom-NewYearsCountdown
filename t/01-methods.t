#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;

plan tests => 6;

use WebService::TimeAndDateCom::NewYearsCountdown;

my $hny = WebService::TimeAndDateCom::NewYearsCountdown->new;
isa_ok($hny, 'WebService::TimeAndDateCom::NewYearsCountdown');
can_ok($hny, qw/new  hny  error  _get_data  _parse  _set_error/);

my $all_data = $hny->hny;
SKIP: {
    unless ( $all_data ) {
        my $error = $hny->error;
        $error or BAIL_OUT('No data and no error; something is terribly wrong');
        $error =~ /^Parse/ and BAIL_OUT(
            $error . ' If this error repeats, it\'s likely the module is broken'
            . '. Please inform the author at zoffix@cpan.org'
        );

        skip 'Got network error: ' . $error, 2;
    }

    is(ref $all_data, 'ARRAY', '->hny() returns an arrayref');
    cmp_deeply(
        $all_data,
        array_each(
            {
                'tz' => re('^(ACDT|ACST|AEDT|AEST|AFT|AKST|ANAT|ART|AST|AoE|BOT|BRST|BST|CET|CHADT|CST|CST|CVT|CWST|EET|EST|GMT|HAST|IRST|IST|JST|LINT|MART|MMT|MSK|MST|NFT|NPT|NST|NUT|NZDT|PST|UZT|VET|WIB)$'),
                'time_left' => re('.'),
                'countries' => re('.'),
                'cities' => re('.'),
            }
        ),
        '->hny() returns sane data',
    );
}

SKIP:{
    my $est = $hny->hny('EST');
    unless ( $est ) {
        my $error = $hny->error;
        $error or BAIL_OUT('No data and no error; something is terribly wrong');
        $error =~ /^Parse/ and BAIL_OUT(
            $error . ' If this error repeats, it\'s likely the module is broken'
            . '. Please inform the author at zoffix@cpan.org'
        );

        skip 'Got network error: ' . $error, 1;
    }

    cmp_deeply(
        $est,
        {
            'tz' => re('^(ACDT|ACST|AEDT|AEST|AFT|AKST|ANAT|ART|AST|AoE|BOT|BRST|BST|CET|CHADT|CST|CST|CVT|CWST|EET|EST|GMT|HAST|IRST|IST|JST|LINT|MART|MMT|MSK|MST|NFT|NPT|NST|NUT|NZDT|PST|UZT|VET|WIB)$'),
            'time_left' => re('.'),
            'countries' => re('.'),
            'cities' => re('.'),
        },
        '->hny(\'EST\') returns sane data',
    );
}

$hny->hny('FOOBAR');
ok(
    (
        $hny->error eq 'Didn\'t find time zone FOOBAR'
        or $hny->error =~ /^Network/
    ),
    '->error() works',
);
