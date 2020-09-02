MODULE = UV::Raw                 PACKAGE = UV::Raw::EventLoop

int
RUN_DEFAULT(...)
	CODE:
		XSRETURN_IV (UV_RUN_DEFAULT);

int
RUN_ONCE(...)
	CODE:
		XSRETURN_IV (UV_RUN_ONCE);

int
RUN_NOWAIT(...)
	CODE:
		XSRETURN_IV (UV_RUN_NOWAIT);

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
run (self, ...)
	EventLoop self

	PREINIT:
		int rc;
		uv_run_mode mode = UV_RUN_DEFAULT;

	CODE:
		if (items >= 2)
			mode = SvIV (ST (1));

		rc = uv_run (self, mode);
		uv_check_error (rc);

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

