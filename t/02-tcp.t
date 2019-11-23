#!perl

use Test::More;
use UV::Raw;

my $el = UV::Raw::EventLoop->new;
my $tcp = UV::Raw::TCP->new ($el);
isa_ok $tcp, 'UV::Raw::TCP';
isa_ok $tcp, 'UV::Raw::Stream';
isa_ok $tcp, 'UV::Raw::Handle';

done_testing;

