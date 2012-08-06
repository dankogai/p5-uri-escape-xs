use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'URI::Escape::XS',
    AUTHOR        => 'Dan Kogai <dankogai@dan.co.jp>',
    VERSION_FROM  => 'lib/URI/Escape/XS.pm',
    ABSTRACT_FROM => 'lib/URI/Escape/XS.pm',
    LICENSE       => 'perl',
    PL_FILES      => {},
    PREREQ_PM     => { 'Test::More' => 0, },
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'URI-Escape-XS-*' },
);
