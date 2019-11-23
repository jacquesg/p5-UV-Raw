#!perl

use Test::More;
use UV::Raw;

my $el = UV::Raw::EventLoop->new;
isa_ok $el, 'UV::Raw::EventLoop';

done_testing;

