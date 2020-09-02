MODULE = UV::Raw                 PACKAGE = UV::Raw::Handle

void
DESTROY (self)
	Handle self

	CODE:
		uv_close (self, uv_raw__close_cb);

