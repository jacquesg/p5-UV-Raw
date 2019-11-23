MODULE = UV::Raw                 PACKAGE = UV::Raw::Process

BOOT:
{
	AV *isa = get_av ("UV::Raw::Process::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Handle", 0));
}
