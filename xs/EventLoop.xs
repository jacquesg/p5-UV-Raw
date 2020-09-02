MODULE = UV::Raw                 PACKAGE = UV::Raw::EventLoop

EventLoop
new (class)
	SV *class

	PREINIT:
		uv_raw_eventloop *self;

	CODE:
		Newxz (self, 1, uv_raw_eventloop);

		uv_loop_init (self);

		RETVAL = self;

	OUTPUT: RETVAL

void
DESTROY (self)
	EventLoop self

	PREINIT:
		int rc = UV_EBUSY;

	CODE:
		while (rc == UV_EBUSY)
		{
			uv_run (self, UV_RUN_ONCE);
			rc = uv_loop_close (self);
		}

		Safefree (self);

