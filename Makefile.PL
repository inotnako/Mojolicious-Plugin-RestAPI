use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::RestAPI',
  VERSION_FROM => 'lib/Mojolicious/Plugin/RestAPI.pm',
  AUTHOR       => 'Anton Konovalov <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '3.39', 'DBIx::Class' => '0.08200'},
  test         => {TESTS => 't/*.t'}
);
