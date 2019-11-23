MODULE = UV::Raw                 PACKAGE = UV::Raw::Signal

BOOT:
{
	AV *isa = get_av ("UV::Raw::Signal::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Handle", 0));
}
