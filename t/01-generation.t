package My::Schema::Foo;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components('PK::WebGUI::Session', 'Core');
__PACKAGE__->table('foo');
__PACKAGE__->add_columns( id => { is_auto_increment => 1 }, 'foo' );
__PACKAGE__->set_primary_key('id');

#-----------------------------------------------------------------

package My::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->storage_type('::WebGUI::Session');
__PACKAGE__->load_classes('Foo');

#-----------------------------------------------------------------

package main;

use strict;
use warnings;

use DBI;
use Test::MockObject;
use Test::More tests => 2;

my $dbh = DBI->connect('dbi:SQLite:dbname=:memory:');
$dbh->do(q{
    CREATE TABLE foo (
        id  VARCHAR(22) PRIMARY KEY,
        foo text
    )
});

#   ids should be 22 chars
#   0123456789012345678901
my @ids = qw(
    aGeneratedIdThatIKnows
    fooBarBazBluhBlahQuuux
);

my $i;

my $session = Test::MockObject->new
    ->mock(db       => sub { shift })
    ->mock(id       => sub { shift })
    ->mock(dbh      => sub { $dbh })
    ->mock(generate => sub { $ids[$i++] });

$session->set_isa('WebGUI::Session');

my $d1 = { foo => 'bar' };
my $d2 = { foo => 'baz', id => 'new' };

my $schema = My::Schema->connect($session);
my $rs     = $schema->resultset('Foo');
is($rs->create($d1)->id, $ids[0], 'with nothing specified');
is($rs->create($d2)->id, $ids[1], 'with new specified');
