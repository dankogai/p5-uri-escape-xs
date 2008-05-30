#!perl -w
#
# $Id: 03-hashu.t,v 0.1 2007/04/27 17:17:46 dankogai Exp dankogai $
#
# Original as URI-1.35/t/escape.t
#

use URI::Escape::XS;
use Test::More tests => 6;
use Encode;

my %esc =
  map { encode_utf8($_) } (
    '%uHHHH'                   => "%uHHHH",
    '%uD869%uDEB2%u5F3E%u0064' => "\x{2a6b2}\x{5F3E}d"
  );

for my $k (keys %esc) {
    is decodeURIComponent($k) => $esc{$k}, qq{decodeURI("$k")};
}

{
    my $warn;
    local($SIG{__WARN__}) = sub { $warn = shift };
    is decodeURIComponent('%uD869') => '', qq{decodeURI("%uD869")};
    like $warn => qr/lo surrogate is missing/, $warn;
    is decodeURIComponent('%uDEB2') => '', qq{decodeURI("%uDEB2")};
    like $warn => qr/invalid surrogate hi/, $warn;
}
