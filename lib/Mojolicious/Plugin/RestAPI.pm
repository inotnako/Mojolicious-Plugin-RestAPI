package Mojolicious::Plugin::RestAPI;
use Mojo::Base 'Mojolicious::Plugin';
use utf8;

our $VERSION = '0.01';

has conf => sub { +{} };

sub register 
	{
	my ($self, $app, $conf) = @_;
	# default values
	$self->conf( $conf ) if $conf;
	my $r = $conf->{route} || $app->routes; 
	my $schema = $conf->{schema} || $app->schema;
	my $rest = $r->bridge($conf->{url}||'/rest_api');
	my $id_property = $conf->{id_property}||'id';
        #GET - read all
	$rest->get
		(
		'/:table' => sub
			{
			my $self = shift;
			my $table = $self->stash('table');
			my ($page, $start, $limit) = 
				(
				$self->param('page')||1,
				$self->param('start')||0,
				$self->param('limit')||25
				);
			if( $table =~ /^\w+$/ and $schema->resultset($table) )
				{
				my $rs = $schema->resultset($table);
				$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
				my $hash;
				if($limit and $page)
					{
					$rs = $rs->slice($start,$page*$limit);
					$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
					}
				@$hash = $rs->all;
				my $json = Mojo::JSON->encode($hash);
				utf8::decode($json);
				return $self->render(text => $json);
				}
			else
				{                        
				return $self->render
					(
					json => 
						{
						success => Mojo::JSON->false,
						error => "No find table with name - $table"
						}
					);
				}
			}
		);
	#GET - read
	$rest->get
		(
		'/:table/:id' => sub
			{
			my $self = shift;
			my ($table,$id) = ($self->stash('table'),$self->stash('id'));
			if
			($table =~ /^\w+$/ and $schema->resultset($table))
				{
                                my $rs = $schema->resultset($table);
                                $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
                                my $hash;
                                if($id eq 'all') { @$hash = $rs->all; }
				elsif($id eq 'last')
					{
					$hash = $rs->search
						(
							{},
							{
							order_by => {-desc => $id_property},
							result_class => 'DBIx::Class::ResultClass::HashRefInflator'
							},
						)->next;
					}
                                elsif($id eq 'first') { $hash = $rs->first;}
                                elsif($id =~ /^slice\((\d+),(\d+)\)$/)
					{
					$rs = $rs->slice($1,$2);
					$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
					@$hash = $rs->all;
					}
				elsif($id =~ /^\d+$/)
					{
					$hash = $rs->find({$id_property => $id});
					if($hash->{$id_property} and $hash->{$id_property} =~ /^\d+$/)
						{
						$hash->{success} = Mojo::JSON->true;
						}
					else
						{
						$hash->{success} = Mojo::JSON->false;
						$hash->{msg} = "No find data in $table by n - $id"
						}
					}
				my $json = Mojo::JSON->encode($hash);
				utf8::decode($json);
				return $self->render(text => $json);
				}
			$self->render
				(
				json => 
					{
					success => Mojo::JSON->false,
					error => "No find table with name - $table"
					}
				);
			}
		);
	#PUT - update
	$rest->put
		(
		'/:table/:id' => sub 
			{
			my $self = shift;
			my ($params,$table,$id) = ($self->req->json,$self->stash('table'),$self->stash('id'));
			if( $table =~ /^\w+$/ and $schema->resultset($table) )
				{
				my $row = $schema->resultset($table)->find({$id_property => $id});
				$row->update($params);
				return $self->render
					(
					json => 
						{
						success 	=> Mojo::JSON->true,
						$id_property   	=> $params->{$id_property}
						}
					);
				}
			else
				{                        
				return $self->render
					(
					json => 
						{
						success => Mojo::JSON->false,
						error => "No find table with name - $table"
						}
					);
				}
			}
		);
	#POST - create
	$rest->post
		(
		'/:table' => sub
			{
			$self = shift;
			my ($params,$table) = ($self->req->json,$self->stash('table'));
			if( $table =~ /^\w+$/ and $schema->resultset($table) )
				{
				my $rs = $schema->resultset($table);
				my $row = $rs->create($params);
				return $self->render
					(
					json => 
						{
						success => Mojo::JSON->true,
						$id_property => $row->$id_property 
						}
					);
				}
			else
				{                        
				return $self->render
					(
					json => 
						{
						success => Mojo::JSON->false,
						error => "No find table with name - $table"
						}
					);
				}
			}
		);
	#DELETE - destroy
	$rest->delete
		(
		'/:table/:id' => sub
			{
			my $self = shift;
			my ($table, $id) = ($self->stash('table'),$self->stash('id'));
			if( $table =~ /^\w+$/ and $schema->resultset($table) )
				{
				my $row = $schema->resultset($table)->find({$id_property => $id})->delete;
				return $self->render
					(
					json => 
						{
						success => Mojo::JSON->true,
						$id_property   => $row->$id_property
						}
					);
				}
			else
				{
				return $self->render
					(
					json => 
						{
						success => Mojo::JSON->false,
						error => "No find table with name - $table"
						}
					);
				}
			}
		);
	}
1;
__END__

=head1 NAME

Mojolicious::Plugin::RestAPI - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('RestAPI');

  # Mojolicious::Lite
  plugin 'RestAPI';

=head1 DESCRIPTION

L<Mojolicious::Plugin::RestAPI> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::RestAPI> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<register>

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
