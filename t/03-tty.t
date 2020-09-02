#!perl

use Test::More;
use UV::Raw;

my $el = UV::Raw::EventLoop->new;

my $stdin = UV::Raw::TTY->new ($el, 0);
isa_ok $stdin, 'UV::Raw::TTY';

done_testing;

