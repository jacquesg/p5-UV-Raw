#!perl

use Test::More;
use UV::Raw;

my $el = UV::Raw::EventLoop->new;
isa_ok $el, 'UV::Raw::EventLoop';

# these do nothing, because we have nothing happening right now...
$el->run;
$el->run ($el->RUN_DEFAULT);
$el->run ($el->RUN_ONCE);
$el->run ($el->RUN_NOWAIT);

done_testing;

