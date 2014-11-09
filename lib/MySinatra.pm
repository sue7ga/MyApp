package MySinatra;
use strict;
use warnings;
use utf8;
use Plack::Request;
use Encode;
use Text::Xslate;
use File::Spec;
use File::Basename qw/dirname/;

sub new{
  my $class = shift;
  bless {
   tx => Text::Xslate->new({
   			    path => File::Spec->catfile(dirname(__FILE__),File::Spec->updir,'view'),}),
  handlers => {},
  },$class;
}

sub to_app{
  my $self = shift;
  sub{
     my $env = shift;
     my $req = Plack::Request->new($env);
     my $res = $req->new_response;
     $res->status(200);
     $res->headers({'Content-Type' => 'text/html; charset=UTF-8'});
     my $handlers = $self->{handlers}{$req->method}{$req->path_info};
     if(defined($handlers)){
            $handlers->($req,$res);
     }else{
            $res->body("not found");
     }
     $res->finalize;
  };
}

sub get{
  my $self = shift;
  my ($path,$handler) = @_;
  $self->{handlers}{POST}{$path} = $handler;
}

sub param{
 my $self = shift;
 my($req,$name) = @_;
 decode_utf8($req->param($name));
}

sub render{
  my $self = shift;
  my ($view_path,$vars) = @_;
  encode_utf8($self->{tx}->render($view_path,$vars));
}


1;
