use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    license       => 'perl',
    dist_name     => 'DBIx-Class-WebGUI',
    dist_abstract => 'WebGUI integration for DBIx::Class',
    dist_author   => 'Paul Driver <paul@plainblack.com>',
    module_name   => 'DBIx::Class::Storage::WebGUI::Session',

    requires => {
        'DBIx::Class' => 0,
    },

    build_requires => {
        'Test::More'       => 0,
        'Test::MockObject' => 0,
        'DBI'              => 0,
        'DBD::SQLite'      => 0,
    },

    add_to_cleanup     => [ 'DBIx-Class-WebGUI-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
