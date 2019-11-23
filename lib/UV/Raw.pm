package UV::Raw;

use strict;
use warnings;

require XSLoader;
XSLoader::load ('UV::Raw', $UV::Raw::VERSION);

use UV::Raw::Async;
use UV::Raw::EventLoop;
use UV::Raw::Handle;
use UV::Raw::Process;
use UV::Raw::Pipe;
use UV::Raw::Poll;
use UV::Raw::Signal;
use UV::Raw::Stream;
use UV::Raw::Timer;
use UV::Raw::TCP;
use UV::Raw::TTY;

=head1 NAME

UV::Raw - Perl bindings to the msgpack C library

=head1 SYNOPSIS

	use UV::Raw;

=head1 DOCUMENTATION

=head1 AUTHOR

Jacques Germishuys <jacquesg@striata.com>

=head1 LICENSE AND COPYRIGHT

Copyright 2019 Jacques Germishuys.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of UV::Raw

