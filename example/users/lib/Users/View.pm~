package Users::View;
use Mojo::Base 'Mojolicious::Controller';

sub show
	{
	my $self = shift;
	my ($controllers,$start_view) = ($self->stash('controllers')||'Users',$self->stash('start_view')||'Viewport');
	$self->render
		(
		template => 'extjs/config',
		controllers => $controllers,
		start_view => $start_view,
		debug => 1,
		attrs => 
			{
			title => 'hello',
			header => 'mojo',
			body => 'foo bar'
			}
		);
	}
1; 