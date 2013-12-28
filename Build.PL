use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WebService::TimeAndDateCom::NewYearsCountdown',
    license             => 'Artistic_2_0',
    dist_author         => q{Zoffix Znet <zoffix@cpan.org>},
    dist_version_from   => 'lib/WebService/TimeAndDateCom/NewYearsCountdown.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
        'Test::Deep' => 0,
    },
    requires => {
        'Moo'            => 0,
        'Mojo::DOM'      => 0,
        'LWP::UserAgent' => 0,
        'perl' => '5.006',
    },
    add_to_cleanup     => [ 'WebService-TimeAndDateCom-NewYearsCountdown-*' ],
    create_makefile_pl => 'traditional',
);
if ( $ENV{RELEASE_TESTING} ) {
    system('pod2text lib/WebService/TimeAndDateCom/NewYearsCountdown.pm > README');
}

$builder->create_build_script();
