MODULE = UV::Raw                 PACKAGE = UV::Raw::Poll

BOOT:
{
	AV *isa = get_av ("UV::Raw::Poll::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Handle", 0));
}
