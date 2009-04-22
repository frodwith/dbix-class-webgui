#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'DBIx::Class::Storage::WebGUI::Session' );
	use_ok( 'DBIx::Class::PK::WebGUI::Session' );
}

diag( "Testing DBIx::Class::Storage::WebGUI::Session $DBIx::Class::Storage::WebGUI::Session::VERSION, Perl $], $^X" );
