package WebService::TimeAndDateCom::NewYearsCountdown;

use Moo;
use Mojo::DOM;
use LWP::UserAgent;
our $VERSION = '1.002';

use constant TIME_AND_DATE_SITE_URL
    => 'http://www.timeanddate.com/counters/multicountdown.html';


has error => ( is => 'rw', init_arg => undef, );
has _ua => (
    is          => 'ro',
    init_arg    => undef,
    default     => sub {
        LWP::UserAgent->new(
            timeout => 30,
            agent => 'Mozilla/5.0 (X11; Ubuntu; Linux i686; '
                .'rv:26.0) Gecko/20100101 Firefox/26.0',
        );
    },
);

sub hny {
    my ( $self, $tz ) = @_;

    my $data = $self->_get_data
        or return;

    if ( $tz ) {
        $tz = uc $tz;
        $tz = 'GMT' if $tz eq 'UTC';

        my ( $tz_data ) = grep $_->{tz} eq $tz, @$data
            or return $self->_set_error('Didn\'t find time zone ' . $tz);

        return $tz_data;
    }

    return $data;
}

sub _get_data {
    my $self = shift;

    my $res = $self->_ua->get( TIME_AND_DATE_SITE_URL );

    return $self->_set_error('Network error: ' . $res->status_line)
        unless $res->is_success;

    my $parsed_data = $self->_parse( $res->content )
        or return; # errored out and the error is already set

    return $parsed_data;
}

sub _parse {
    my ( $self, $content ) = @_;

    my @data;
    eval {
        my $dom = Mojo::DOM->new( $content );
        for my $tr ( $dom->find('table.mpad.tbbox tbody tr')->each ) {
            my %row;
            @row{qw/countries  tz  cities  time_left/}
            = map $_->all_text, $tr->find('td')->each;
            push @data, +{ %row };
        }
    };

    $@ and return $self->_set_error('Parse error: ' . $@);
    return \@data;
}

sub _set_error {
    my ( $self, $error ) = @_;
    $self->error( $error );
    return;
}

'HAPPY NEW YEAR!!!!';

__END__

=encoding utf8

=head1 NAME

WebService::TimeAndDateCom::NewYearsCountdown - obtain count downs until New Years from www.timeanddate.com

=head1 SYNOPSIS

    use WebService::TimeAndDateCom::NewYearsCountdown;

    my $hny = WebService::TimeAndDateCom::NewYearsCountdown->new;

    my $data = $hny->hny('EST')
        or die $hny->error;

    printf "%s left until New Year in %s (%s, [%s])\n",
        @$data{qw/time_left  tz  countries  cities/};


    my $all_timezones_data = $hny->hny
        or die $hny->error;

    for ( @$all_timezones_data ) {
        printf "%s left until New Year in %s (%s, [%s])\n",
            @$_{qw/time_left  tz  countries  cities/};
    }

=head1 DESCRIPTION

Module obtains count downs until New Years from L<www.timeanddate.com>.

=head1 NOTICE TO THE USER

It's worth noting that L<www.timeanddate.com> has this message
at the top of its HTML code:

    scripts and programs that download content transparent to
    the user are not allowed without permission

...I'm not 100% sure about its meaning.

=head1 METHODS

=head2 C<new>

    my $hny = WebService::TimeAndDateCom::NewYearsCountdown->new;

Constructs and returns a new
C<WebService::TimeAndDateCom::NewYearsCountdown> object. Does not take
any arguments.

=head2 C<hny>

    my $all_timezones_data = $hny->hny
        or die $hny->error;

    my $data = $hny->hny('EST')
        or die $hny->error;

C<hny> stands for B<H>appy B<N>ew B<Y>ear.
B<Takes one optional> argument, which is the time zone for which to
retrieve the data; valid time zones are listed below.
B<On failure> returns an C<undef> or an empty list, depending on the
context, and the reason for error will be available using the
C<< ->error >> method.
B<On success> returns New Years countdown data.
If the time zone is specified,
returns a single hashref for that time zone, otherwise returns an arrayref
of hashrefs of data for each time zone. The format of the hashrefs is as
follows:

    {
        'tz' => 'EST',
        'time_left' => '4 days, 02:10:04',
        'countries' => 'regions of U.S.A., regions of Canada and 12 more',
        'cities' => 'New York, Washington DC, Detroit, Havana'
    }

=over 4

=item * C<tz> time zone code

=item * C<time_left> time until New Years in that time zone

=item * C<countries> a brief list of regions/countries in that time zone

=item * C<cities> a brief list of cities in that time zone

=back

=head3 Valid Time Zones Values For C<< ->hny >>

    ACDT
    ACST
    AEDT
    AEST
    AFT
    AKST
    ANAT
    ART
    AST
    AoE
    BOT
    BRST
    BST
    CET
    CHADT
    CST
    CST
    CVT
    CWST
    EET
    EST
    GMT
    HAST
    IRST
    IST
    JST
    LINT
    MART
    MMT
    MSK
    MST
    NFT
    NPT
    NST
    NUT
    NZDT
    PST
    UZT
    UTC
    VET
    WIB

=head2 C<error>

    my $all_timezones_data = $hny->hny
        or die $hny->error;

B<Takes> no arguments. Returns the human-readable error message, when the
last call to C<< ->hny >> fails.

=head1 AUTHOR

Zoffix Znet, C<< <zoffix at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-timeanddatecom-newyearscountdown at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-TimeAndDateCom-NewYearsCountdown>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::TimeAndDateCom::NewYearsCountdown

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-TimeAndDateCom-NewYearsCountdown>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-TimeAndDateCom-NewYearsCountdown>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-TimeAndDateCom-NewYearsCountdown>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-TimeAndDateCom-NewYearsCountdown/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Zoffix Znet.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut
