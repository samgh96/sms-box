ASM = wla-z80
LD = wlalink
LDFLAGS = -d -r -v -S

all : compile link

compile :
	$(ASM) -o object.o $(wildcard *.z80)

link :
	echo "[objects]" > linkfile
	echo object.o >> linkfile
	$(LD) $(LDFLAGS) linkfile output.sms

clean :
	rm -f object.o linkfile output.sms.sym output.sym output.sms
