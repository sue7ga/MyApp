use strict;
use warnings;
use utf8;
use MySinatra;

my $ms = MySinatra->new();

my $root = sub{
  my ($req,$res) = @_;
  my $msg = $ms->param($req,'msg');
  my $body = $ms->render('index.tx',{msg => $msg});
  $res->body($body);
};

$ms->get('/' => $root);
$ms->get('/' => $root);

use Plack::Builder;
use File::Spec;
use File::Basename qw/dirname/;

builder{
  enable 'Plack::Middleware::Static',
  path => qr{^/static/},
  root => File::Spec->catdir(dirname(__FILE__),File::Spec->updir);
  
  $ms->to_app;
}


