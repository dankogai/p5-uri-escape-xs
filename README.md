[![build status](https://secure.travis-ci.org/dankogai/p5-uri-escape-xs.png)](http://travis-ci.org/dankogai/p5-uri-escape-xs)

# NAME

URI::Escape::XS - Drop-In replacement for URI::Escape

# VERSION

$Id: XS.pm,v 0.14 2016/06/09 11:09:14 dankogai Exp $

# SYNOPSIS

    # use it instead of URI::Escape
    use URI::Escape::XS qw/uri_escape uri_unescape/;
    $safe = uri_escape("10% is enough\n");
    $verysafe = uri_escape("foo", "\0-\377");
    $str  = uri_unescape($safe);

    # or use encodeURIComponent and decodeURIComponent
    use URI::Escape::XS;
    $safe = encodeURIComponent("10% is enough\n");
    $str  = decodeURIComponent("10%25%20is%20enough%0A");

    # if you have CNet::IDN::Encode installed
    $safe = encodeURIComponentIDN("http://ドメイン名例.jp/dan/");
    $str  = decodeURIComponentIDN("http:%2F%2Fxn--eckwd4c7cu47r2wf.jp%2Fdan%2F");

# DESCRIPTION

    URI::Escape::XS is a drop-in replacement for URI::Escape for common cases which
    offers much faster performance by using compiled XS code.

    This module requires Perl 5.8.1 compared to 5.6.1 for URI::Escape.
    The uri_escape_utf8 function from URI::Escape is not present here, as
    our uri_escape() method handles UTF-8 characters automatically.

# EXPORT

## by default

["encodeURIComponent"](#encodeuricomponent) and ["decodeURIComponent"](#decodeuricomponent)

["encodeURIComponentIDN"](#encodeuricomponentidn) and ["decodeURIComponentIDN"](#decodeuricomponentidn) if either
[Net::LibIDN](https://metacpan.org/pod/Net%3A%3ALibIDN) or [Net::IDN::Encode](https://metacpan.org/pod/Net%3A%3AIDN%3A%3AEncode) is available

## on demand

["uri\_escape"](#uri_escape) and ["uri\_unescape"](#uri_unescape)

# FUNCTIONS

## encodeURIComponent

Does what JavaScript's encodeURIComponent does.

    $uri = encodeURIComponent("http://www.example.com/");
    # http%3A%2F%2Fwww.example.com%2F

Note you cannot customize characters to escape.  If you need to do so,
use ["uri\_escape"](#uri_escape).

## decodeURIComponent

Does what JavaScript's decodeURIComponent does.

    $str = decodeURIComponent("http%3A%2F%2Fwww.example.com%2F");
    # http://www.example.com/

It decode not only %HH sequences but also %uHHHH sequences, with
surrogate pairs correctly decoded.

    $str = decodeURIComponent("%uD869%uDEB2%u5F3E%u0061");
    # \x{2A6B2}\x{5F3E}a

This function UNCONDITIONALLY returns the decoded string with utf8 flag off.  To get utf8-decoded string, use [Encode](https://metacpan.org/pod/Encode) and

    decode_utf8(decodeURIComponent($uri));

This is the correct behavior because you cannot tell if the decoded
string actually contains UTF-8 decoded string, like ISO-8859-1 and
Shift\_JIS.

## encodeURIComponentIDN

Same as ["encodeURIComponent"](#encodeuricomponent) except that the host part is encoded in
punycode.  Either [Net::LibIDN](https://metacpan.org/pod/Net%3A%3ALibIDN) or [Net::IDN::Encode](https://metacpan.org/pod/Net%3A%3AIDN%3A%3AEncode) is required to
use this function.

URIs with Internationalizing Domain Names require two encodings:
Punycode for host part and URI escape for the rest.

Currently only FULL URIs with `http:` or `https:` are supported.

## decodeURIComponentIDN

Same as ["decodeURIComponent"](#decodeuricomponent) except that the host part is encoded in
punycode.  Either [Net::LibIDN](https://metacpan.org/pod/Net%3A%3ALibIDN) or [Net::IDN::Encode](https://metacpan.org/pod/Net%3A%3AIDN%3A%3AEncode) is required to
use this function.

## uri\_escape

Does exactly the same as [URI::Escape](https://metacpan.org/pod/URI%3A%3AEscape)::uri\_escape() **except**
when utf8-flagged string is fed.

[URI::Escape](https://metacpan.org/pod/URI%3A%3AEscape)::uri\_escape() croak and urge you to
`uri_escape_utf8()` but it is pointless because URI itself has no
such things as utf8 flag.  The function in this module ALWAYS TREATS
the string as byte sequence.  That way you can safely use this
function without worrying about utf8 flags.

Note this function is NOT EXPORTED by default.  That way you can use
[URI::Escape](https://metacpan.org/pod/URI%3A%3AEscape) and [URI::Escape::XS](https://metacpan.org/pod/URI%3A%3AEscape%3A%3AXS) simultaneously.

## uri\_unescape

Does exactly the same as [URI::Escape](https://metacpan.org/pod/URI%3A%3AEscape)::uri\_escape() **except**
when %uHHHH is fed.

[URI::Escape](https://metacpan.org/pod/URI%3A%3AEscape)::uri\_unescape() simply ignores %uHHHH sequences while
the function in this module does decode it into the corresponding
UTF-8 **byte sequence**.

Like [uri\_escape](https://metacpan.org/pod/uri_escape), this function is NOT EXPORTED by default.

## Note on the %uHHHH sequence

With this module the resulting strings never have the utf8 flag on.
So if you want to decode it to perl utf8, You have to explicitly
decode via [Encode](https://metacpan.org/pod/Encode).  Remember.  URIs have always been a byte
sequence, not UTF-8 characters.

If the %uHHHH sequence became standard, you could have safely told if a
given URI is in Unicode.  But more fortunately than unfortunately, the
RFC proposal was rejected so you cannot tell which encoding is used
just by looking at the URI.

[http://en.wikipedia.org/wiki/Percent-encoding#Non-standard\_implementations](http://en.wikipedia.org/wiki/Percent-encoding#Non-standard_implementations)

I said fortunately because %uHHHH can be nasty for non-BMP characters.
Since each %uHHHH can hold one 16-bit value, you need a _surrogate
pair_ to represent it if it is U+10000 and above.

In spite of that, there are a significant number of URIs with %uHHHH
escapes.  Therefore this module supports decoding only.

# SPEED

Since this module uses XS, it is really fast except for
uri\_escape("noop").

Regexp which is used in [URI::Escape](https://metacpan.org/pod/URI%3A%3AEscape) is really fast for non-matching
but slows down significantly when it has to replace string.

## BENCHMARK

On Macbook Pro 2GHz, Perl 5.8.8.

    http://www.google.co.jp/search?q=%E5%B0%8F%E9%A3%BC%E5%BC%BE
    ============================================================
    Unescape it
    -----------
    U::E      58526/s       --     -88%
    U::E::XS 486968/s     732%       --
    --------------
    Escape it back
    --------------
    U::E      30046/s       --     -78%
    U::E::XS 136992/s     356%       --

    www.example.com
    ===============
    Unescape it
    -----------
                  Rate     U::E U::E::XS
     U::E     821972/s       --      -4%
     U::E::XS 854732/s       4%       --
    --------------
    Escape it back
    -------------
    U::E::XS 522969/s       --      -7%
    U::E     565112/s       8%       --

# AUTHOR

Dan Kogai, `<dankogai at cpan.org>`

# BUGS

Please report any bugs or feature requests to
`bug-uri-escape-xs at rt.cpan.org`, or through the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=URI-Escape-XS](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=URI-Escape-XS).
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc URI::Escape::XS

You can also look for information at:

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/URI-Escape-XS](http://annocpan.org/dist/URI-Escape-XS)

- CPAN Ratings

    [http://cpanratings.perl.org/d/URI-Escape-XS](http://cpanratings.perl.org/d/URI-Escape-XS)

- RT: CPAN's request tracker

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=URI-Escape-XS](http://rt.cpan.org/NoAuth/Bugs.html?Dist=URI-Escape-XS)

- Search CPAN

    [http://search.cpan.org/dist/URI-Escape-XS](http://search.cpan.org/dist/URI-Escape-XS)

# ACKNOWLEDGEMENTS

Gisle Aas for [URI::Escape](https://metacpan.org/pod/URI%3A%3AEscape)

Koichi Taniguchi for [URI::Escape::JavaScript](https://metacpan.org/pod/URI%3A%3AEscape%3A%3AJavaScript)

Thomas Jacob for [Net::LibIDN](https://metacpan.org/pod/Net%3A%3ALibIDN)

Claus Färber for [Net::IDN::Encode](https://metacpan.org/pod/Net%3A%3AIDN%3A%3AEncode)

# COPYRIGHT & LICENSE

Copyright 2007-2020 Dan Kogai, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
