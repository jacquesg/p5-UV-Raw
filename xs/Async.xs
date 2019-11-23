MODULE = UV::Raw                 PACKAGE = UV::Raw::Async

BOOT:
{
	AV *isa = get_av ("UV::Raw::Async::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Handle", 0));
}
