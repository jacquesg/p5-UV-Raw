MODULE = UV::Raw                 PACKAGE = UV::Raw::TCP

BOOT:
{
	AV *isa = get_av ("UV::Raw::TCP::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Stream", 0));
}

TCP
new (class, loop)
	SV *class
	SV *loop;

	PREINIT:
		uv_raw_tcp *self;

	CODE:
		Newxz (self, 1, uv_raw_tcp);

		uv_tcp_init (UV_SV_TO_PTR (EventLoop, loop), self);

		RETVAL = self;

	OUTPUT: RETVAL

void
DESTROY (self)
	TCP self

	CODE:
		Safefree (self);
