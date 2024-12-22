if [ "$2" == "release" ]; then
qemu-system-x86_64 \
    -bios /usr/share/OVMF/x64/OVMF.4m.fd \
    -drive file="$1/image.img",format=raw,cache=writeback,snapshot=off \
    -M q35 \
    -m 128 \
    -global isa-debugcon.iobase=0xe9 \
    -debugcon file:debug_output.txt \
    -d cpu_reset,int \
    -no-reboot \
    -enable-kvm \
    -cpu host
elif [ "$2" == "debug" ]; then
qemu-system-x86_64 \
    -bios /usr/share/OVMF/x64/OVMF.4m.fd \
    -drive file="$1/image.img",format=raw,cache=writeback,snapshot=off \
    -M q35 \
    -m 128 \
    -global isa-debugcon.iobase=0xe9 \
    -debugcon file:debug_output.txt \
    -d cpu_reset \
    -no-reboot \
    -enable-kvm \
    -cpu host \
    -S -s
fi