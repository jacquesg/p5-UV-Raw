MODULE = UV::Raw                 PACKAGE = UV::Raw::Timer

BOOT:
{
	AV *isa = get_av ("UV::Raw::Timer::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Handle", 0));
}
