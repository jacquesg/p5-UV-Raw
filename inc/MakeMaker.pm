package inc::MakeMaker;

use Moose;
use Config;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;

	my $template = <<'TEMPLATE';
use strict;
use warnings;
use Config;

# compiler detection
my $is_gcc = length($Config{gccversion});
my $is_msvc = $Config{cc} eq 'cl' ? 1 : 0;
my $legacy_gcc = index ($Config{gccversion}, '4.2.1') != -1 ? 1 : 0;

# os detection
my $is_solaris = ($^O =~ /(sun|solaris)/i) ? 1 : 0;
my $is_windows = ($^O =~ /MSWin32/i) ? 1 : 0;
my $is_linux = ($^O =~ /linux/i) ? 1 : 0;
my $is_osx = ($^O =~ /darwin/i) ? 1 : 0;
my $is_bsd = ($^O =~ /bsd/i) ? 1 : 0;
my $is_openbsd = ($^O =~ /openbsd/i) ? 1 : 0;
my $is_gkfreebsd = ($^O =~ /gnukfreebsd/i) ? 1 : 0;

my $def = '';

my $lib = '';
my $otherldflags = '';
my $inc = '';
my $ccflags = '';

if ($is_windows)
{
	$def .= ' -D_WINSOCK_DEPRECATED_NO_WARNINGS -D_CRT_SECURE_NO_WARNINGS -DFD_SETSIZE=16384';
	$def .= ' -D_WIN32_WINNT=0x0600';

	$lib .= ' -lws2_32 -lrpcrt4 -liphlpapi msvcprt.lib';

	if ($is_msvc)
	{
		$ccflags .= ' -EHsc';
	}
}

my @c_srcs = (glob ('deps/libuv/src/*.c'));

if ($is_windows)
{
}
else
{
	$def .= ' -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE';

	push @c_srcs, 'deps/libuv/src/unix/async.c';
	push @c_srcs, 'deps/libuv/src/unix/core.c';
	push @c_srcs, 'deps/libuv/src/unix/dl.c';
	push @c_srcs, 'deps/libuv/src/unix/fs.c';
	push @c_srcs, 'deps/libuv/src/unix/getaddrinfo.c';
	push @c_srcs, 'deps/libuv/src/unix/getnameinfo.c';
	push @c_srcs, 'deps/libuv/src/unix/loop.c';
	push @c_srcs, 'deps/libuv/src/unix/pipe.c';
	push @c_srcs, 'deps/libuv/src/unix/poll.c';
	push @c_srcs, 'deps/libuv/src/unix/process.c';
	push @c_srcs, 'deps/libuv/src/unix/signal.c';
	push @c_srcs, 'deps/libuv/src/unix/stream.c';
	push @c_srcs, 'deps/libuv/src/unix/tcp.c';
	push @c_srcs, 'deps/libuv/src/unix/thread.c';
	push @c_srcs, 'deps/libuv/src/unix/tty.c';
	push @c_srcs, 'deps/libuv/src/unix/udp.c';

	if ($is_osx)
	{
		$def .= ' -D_DARWIN_UNLIMITED_SELECT=1 -D_DARWIN_USE_64_BIT_INODE=1';

		push @c_srcs, 'deps/libuv/src/unix/bsd-ifaddrs.c';
		push @c_srcs, 'deps/libuv/src/unix/fsevents.c';
		push @c_srcs, 'deps/libuv/src/unix/proctitle.c';
		push @c_srcs, 'deps/libuv/src/unix/kqueue.c';
		push @c_srcs, glob ('deps/libuv/src/unix/darwin*.c');
	}
}

my @c_objs = map { substr ($_, 0, -1) . 'o' } (@c_srcs);

sub MY::c_o {
	my $out_switch = '-o ';

	if ($is_msvc) {
		$out_switch = '/Fo';
	}

	my $line = qq{
.c\$(OBJ_EXT):
	\$(CCCMD) \$(CCCDLFLAGS) "-I\$(PERL_INC)" \$(PASTHRU_DEFINE) \$(DEFINE) \$*.c $out_switch\$@
};

	if ($is_gcc) {
		# disable parallel builds
		$line .= qq{

.NOTPARALLEL:
};
	}
	return $line;
}

# This Makefile.PL for {{ $distname }} was generated by Dist::Zilla.
# Don't edit it but the dist.ini used to construct it.
{{ $perl_prereq ? qq[BEGIN { require $perl_prereq; }] : ''; }}
use strict;
use warnings;
use ExtUtils::MakeMaker {{ $eumm_version }};
use ExtUtils::Constant qw (WriteConstants);

{{ $share_dir_block[0] }}
my {{ $WriteMakefileArgs }}

$WriteMakefileArgs{DEFINE}  .= $def;
$WriteMakefileArgs{LIBS}    .= $lib;
$WriteMakefileArgs{INC}     .= $inc;
$WriteMakefileArgs{CCFLAGS} .= $Config{ccflags} . ' '. $ccflags;
$WriteMakefileArgs{OBJECT}  .= ' ' . join ' ', (@c_objs);
$WriteMakefileArgs{dynamic_lib} = {
	OTHERLDFLAGS => $otherldflags
};

unless (eval { ExtUtils::MakeMaker->VERSION(6.56) }) {
	my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
	my $pp = $WriteMakefileArgs{PREREQ_PM};

	for my $mod (keys %$br) {
		if (exists $pp -> {$mod}) {
			$pp -> {$mod} = $br -> {$mod}
				if $br -> {$mod} > $pp -> {$mod};
		} else {
			$pp -> {$mod} = $br -> {$mod};
		}
	}
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
	unless eval { ExtUtils::MakeMaker -> VERSION(6.52) };

WriteMakefile (%WriteMakefileArgs);
exit (0);

{{ $share_dir_block[1] }}
TEMPLATE

	return $template;
};

override _build_WriteMakefile_args => sub {
	return +{
		%{ super() },
		INC	    => '-I. -Ideps -Ideps/libuv/include -Ideps/libuv/src',
		OBJECT	=> '$(O_FILES)',
	}
};

__PACKAGE__ -> meta -> make_immutable;
