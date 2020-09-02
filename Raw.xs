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

typedef struct
{
	int code;
	SV *message;
	const char *file;
	unsigned int line;
} uv_raw_error;

typedef uv_raw_error *Error;

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

STATIC const COP *uv_closest_cop (pTHX_ const COP *cop, const OP *o, const OP *curop, bool opnext)
{
	dVAR;

	if (!o || !curop || (
	opnext ? o->op_next == curop && o->op_type != OP_SCOPE : o == curop
	))
		return cop;

	if (o->op_flags & OPf_KIDS) {
		const OP *kid;
		for (kid = cUNOPo->op_first; kid; kid = OpSIBLING(kid)) {
			const COP *new_cop;

			if (kid->op_type == OP_NULL && kid->op_targ == OP_NEXTSTATE)
				cop = (const COP *)kid;

			/* Keep searching, and return when we've found something. */
			new_cop = uv_closest_cop(aTHX_ cop, kid, curop, opnext);
			if (new_cop)
				return new_cop;
		}
    }

    return NULL;
}

STATIC Error create_error_obj (int code, SV *message)
{
	Error e;
	const COP *cop;

	Newxz (e, 1, uv_raw_error);
	e -> code = code;
	e -> message = message;

	cop = uv_closest_cop(aTHX_ PL_curcop, OpSIBLING(PL_curcop), PL_op, FALSE);
	if (cop == NULL)
		cop = PL_curcop;

	if (CopLINE (cop))
	{
		e -> file = CopFILE (cop);
		e -> line = CopLINE (cop);
	}
	else
		e -> file = "unknown";

	return e;
}

STATIC Error create_error_obj_fmt (int code, const char *prefix, const char *pat, va_list *list)
{
	Error e;

	e = create_error_obj(code, newSVpv(prefix, 0));
	sv_vcatpvf(e -> message, pat, list);

	return e;
}

STATIC void __attribute__noreturn__ croak_error_obj (Error e)
{
	SV *res = NULL;
	UV_NEW_OBJ (res, "UV::Raw::Error", e);
	SvREFCNT_inc(e -> message);
	croak_sv(res);
}

STATIC void S_uv_check_error(int err, const char *file, int line)
{
	if (err != 0)
	{
		Error e = create_error_obj (err, newSVpv (uv_strerror (err), 0));
		croak_error_obj (e);
	}
}

#define uv_check_error(e) S_uv_check_error(e, __FILE__, __LINE__)


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

