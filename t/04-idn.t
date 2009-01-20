#!perl -w
#
# $Id: 04-idn.t,v 1.1 2009/01/16 08:26:52 dankogai Exp dankogai $
#
# Original as URI-1.35/t/escape.t
#

use URI::Escape::XS;
use Test::More tests => 6;

SKIP:{
    use utf8;
    eval { require Net::IDN::Encode };
    skip 'Net::IDN::Encode required', 6 if $@;
    my $d = 'http://ドメイン名例.jp/dankogai/だん/ダン';
    my $e = 'http:%2F%2Fxn--eckwd4c7cu47r2wf.jp%2Fdankogai%2F%E3%81%A0%E3%82%93%2F%E3%83%80%E3%83%B3';
    is decodeURIComponentIDN($e) => $d, 'decodeURIComponentIDN';
    is encodeURIComponentIDN($d) => $e, 'encodeURIComponentIDN';
    $d = 'http://ドメイン名例.JP:8080/dankogai/だん/ダン';
    $e = 'http:%2F%2Fxn--eckwd4c7cu47r2wf.JP:8080%2Fdankogai%2F%E3%81%A0%E3%82%93%2F%E3%83%80%E3%83%B3';
    is decodeURIComponentIDN($e) => $d, 'decodeURIComponentIDN';
    is encodeURIComponentIDN($d) => $e, 'encodeURIComponentIDN';
    $d = 'http://مثال.إختبار';
    $e = 'http:%2F%2Fxn--mgbh0fb.xn--kgbechtv';
    is decodeURIComponentIDN($e) => $d, 'decodeURIComponentIDN';
    is encodeURIComponentIDN($d) => $e, 'encodeURIComponentIDN';
}
