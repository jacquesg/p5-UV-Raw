MODULE = UV::Raw                 PACKAGE = UV::Raw::TTY

BOOT:
{
	AV *isa = get_av ("UV::Raw::TTY::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Stream", 0));
}
