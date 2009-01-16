#!perl -w
#
# $Id: 03-hashu.t,v 0.2 2008/05/31 00:48:19 dankogai Exp $
#
# Original as URI-1.35/t/escape.t
#

use URI::Escape::XS;
use Test::More tests => 2;

SKIP:{
    use utf8;
    eval { require Net::IDN::Encode };
    skip 'Net::IDN::Encode required', 2 if $@;
    my $d = 'http://弾.jp/dankogai/だん/ダン';
    my $e = 'http:%2F%2Fxn--81t.jp%2Fdankogai%2F%E3%81%A0%E3%82%93%2F%E3%83%80%E3%83%B3';
    is decodeURIComponentIDN($e) => $d, 'decodeURIComponentIDN';
    is encodeURIComponentIDN($d) => $e, 'encodeURIComponentIDN';
}
