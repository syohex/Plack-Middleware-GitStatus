use strict;
use warnings;

use Test::More;
use Plack::Test;

use Plack::Builder;
use Plack::Middleware::GitStatus;

subtest "not git repository" => sub {
    my $app = builder {
        enable 'GitStatus', path => '/git-status', git_dir => "/tmp";
        sub { [200, [ 'Content-Type' => 'text/plain' ], [ "Hello World" ]] };
    };

    test_psgi app => $app, client => sub {
        my $cb = shift;
        my $req = HTTP::Request->new(GET => "http://localhost/git-status");
        my $res = $cb->($req);
        is $res->code, 500;
        like $res->content, qr/^fatal: Not a git repository/;
    };
};

done_testing;
