MODULE = UV::Raw                 PACKAGE = UV::Raw::Stream

BOOT:
{
	AV *isa = get_av ("UV::Raw::Stream::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Handle", 0));
}
