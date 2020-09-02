#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <uv.h>

#define NEED_newRV_noinc
#define NEED_sv_2pvbyte
#define NEED_sv_2pv_flags

#include "ppport.h"

#ifndef MUTABLE_AV
#define MUTABLE_AV(p) ((AV *)MUTABLE_PTR(p))
#endif

typedef uv_async_t uv_raw_async;
typedef uv_loop_t uv_raw_eventloop;
typedef uv_tcp_t uv_raw_tcp;
typedef uv_handle_t uv_raw_handle;
typedef uv_pipe_t uv_raw_pipe;
typedef uv_poll_t uv_raw_poll;
typedef uv_process_t uv_raw_process;
typedef uv_stream_t uv_raw_stream;
typedef uv_tty_t uv_raw_tty;

typedef uv_raw_async *Async;
typedef uv_raw_eventloop *EventLoop;
typedef uv_raw_tcp *TCP;
typedef uv_raw_handle *Handle;
typedef uv_raw_pipe *Pipe;
typedef uv_raw_poll *Poll;
typedef uv_raw_process *Process;
typedef uv_raw_stream *Stream;
typedef uv_raw_tty *TTY;

#define UV_NEW_OBJ(rv, package, sv)                \
	STMT_START {                                       \
		(rv) = sv_setref_pv (newSV(0), package, sv);   \
	} STMT_END

STATIC void *uv_raw_sv_to_ptr (const char *type, SV *sv, const char *file, int line)
{
	SV *full_type = sv_2mortal (newSVpvf ("UV::Raw::%s", type));

	if (!(sv_isobject (sv) && sv_derived_from (sv, SvPV_nolen (full_type))))
		croak("Argument is not of type %s @ (%s:%d)\n",
		SvPV_nolen (full_type), file, line);

	return INT2PTR (void *, SvIV ((SV *) SvRV (sv)));
}

#define UV_SV_TO_PTR(type, sv) \
	uv_raw_sv_to_ptr(#type, sv, __FILE__, __LINE__)

STATIC void uv_raw__close_cb (uv_handle_t *handle)
{
	Safefree (handle);
}

MODULE = UV::Raw               PACKAGE = UV::Raw

INCLUDE: xs/Async.xs
INCLUDE: xs/EventLoop.xs
INCLUDE: xs/Handle.xs
INCLUDE: xs/Pipe.xs
INCLUDE: xs/Poll.xs
INCLUDE: xs/Process.xs
INCLUDE: xs/Signal.xs
INCLUDE: xs/Stream.xs
INCLUDE: xs/Timer.xs
INCLUDE: xs/TCP.xs
INCLUDE: xs/TTY.xs

