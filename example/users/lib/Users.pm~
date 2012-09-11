package Users;
use Mojo::Base 'Mojolicious';
use lib '/home/antonkonovalov/RestAPI/lib/';
use Mojolicious::Plugin::RestAPI;
use Schema;

has schema => sub {
  return Schema->connect('dbi:SQLite:' . ($ENV{TEST_DB} || 'test.db'));
};

# This method will run once at server start
sub startup 
	{
	my $self = shift;
	$self->helper(db => sub { $self->app->schema });
	$self->plugin
		(
		'RestAPI',
			{
			route 	=> $self->routes,
			schema 	=> $self->schema,
			url	=> '/rest',
			id_property => 'n' # id or n 
			}
		);
	my $r = $self->routes;
	$r->route('/')->to(controller => 'view', action => 'show');
	$r->route('/:controllers/:start_view')
		->to(controller => 'view', action => 'show');
	}

1;
