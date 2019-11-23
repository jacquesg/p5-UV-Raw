MODULE = UV::Raw                 PACKAGE = UV::Raw::Pipe

BOOT:
{
	AV *isa = get_av ("UV::Raw::Pipe::ISA", 1);
	av_push (isa, newSVpv ("UV::Raw::Stream", 0));
}
