package DBIx::Class::Storage::WebGUI::Session;

use warnings;
use strict;

use base 'DBIx::Class::Storage::DBI';
use Carp qw(croak);

our $VERSION = '0.1';

=head1 NAME

DBIx::Class::Storage::WebGUI::Session

=head1 DESCRIPTION

A handy class for using the db objects from a WebGUI session in your
DBIx::Class classes.  It also maintains the session object you pass it.  It is
intended to be used in conjuction with DBIx::Class::PK::WebGUI::Session for
autogenerating primary keys in the WebGUI style.

=head1 SYNOPSIS

    package My::Schema;

    use base 'DBIx::Class::Schema';

    __PACKAGE__->storage_type('::WebGUI::Session');
    __PACKAGE__->load_classes();

    package Elsewhere;
    
    use My::Schema;
    use WebGUI::Session;

    my $session = WebGUI::Session->open($root, $conf);
    my $schema = My::Schema->new($session);

=head1 METHODS

The following methods are available from this class:

=cut

#-------------------------------------------------------------------

=head2 connect_info ( info )

Overridden to accept a session as its only info argument instead of the usual
DBI info or coderef.  Pass the session to $schema->connect and what-have-you.

=cut

sub connect_info {
    my ( $self, $info ) = @_;
    my $session = $info->[0];

    croak 'Non-session passed to connect_info'
        unless ref $session && $session->isa('WebGUI::Session');

    $self->{_session} = $session;
    my $getHandle = sub { $session->db->dbh };
    return $self->next::method( [$getHandle] );
}

#-------------------------------------------------------------------

=head2 session

Returns the session associated with this source.

=cut

sub session {
    return shift->{_session};
}

=head1 AUTHOR

Paul Driver, C<< <paul at plainblack.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<< <paul at plainblack.com> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Paul Driver, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

