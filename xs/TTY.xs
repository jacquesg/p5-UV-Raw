MODULE = UV::Raw                 PACKAGE = UV::Raw::TTY

BOOT:
{
	AV *isa = get_av ("UV::Raw::TTY::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Stream", 0));
}

TTY
new (class, loop, fd)
	SV *class
	EventLoop loop
	int fd

	PREINIT:
		uv_raw_tty *self;

	CODE:
		Newxz (self, 1, uv_raw_tty);

		uv_tty_init (loop, self, fd, 0);

		RETVAL = self;

	OUTPUT: RETVAL

