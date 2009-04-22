package DBIx::Class::PK::WebGUI::Session;

use warnings;
use strict;

=head1 NAME

DBIx::Class::PK::WebGUI::Session

=head1 DESCRIPTION

Autogenerates WebGUI GUIDs similar to PK::Auto's autoincrementing.  The
DBIx::Class::Storage in use must provide a 'session' method that returns a
valid WebGUI session (see DBIx::Class::Source::WebGUI::Session).

=head1 SYNOPSIS

    package My::Schema::Thingy;

    use base 'DBIx::Class';

    __PACKAGE__->load_components('PK::WebGUI::Session', 'Core');
    __PACKAGE__->table('thingy');
    __PACKAGE__->add_columns( id => { is_auto_increment => 1 }, 'foo' );
    __PACKAGE__->set_primary_key('id');

    package Elsewhere;

    my $a = $schema->resultset('Thingy')->create({foo => 'bar'});
    # a->id is a WebGUI GUID!

    # this works too
    my $b = $schema->resultset('Thingy')->create({
        foo => 'baz',
        id  => 'new',
    });

=head1 METHODS

The following methods are available from this class:

=cut

#-------------------------------------------------------------------

=head2 insert ( )

Overridden to replace primary key fields with no value (or with the value
'new') with session-generated GUIDs.

=cut

sub insert {
    my $self    = shift;
    my $session = $self->session;

    my @columns = grep {
        my $val = $self->get_column($_);
        !defined $val || $val eq 'new' || ref($val) eq 'SCALAR'
    } $self->primary_columns;

    foreach my $c (@columns) {
        $self->store_column( $c, $session->id->generate() );
    }

    $self->next::method(@_);
}

#-------------------------------------------------------------------

=head2 session ( )

Provided for convenience.  Returns the session object the storage was created
with.

=cut

sub session {
    return shift->result_source->storage->session;
}

=head1 AUTHOR

Paul Driver, C<< <paul at plainblack.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<< <paul at plainblack.com> >>.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Paul Driver, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
