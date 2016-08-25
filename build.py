import argparse
import os
import shutil
import subprocess

os_name = "DaedalOS"

arch = "x86_64"

src_dir = "./src/arch/{}".format(arch)
build_dir = "./build/arch/{}".format(arch)
iso_dir = "./build/isofiles"

flags = {"kernel": "-std=gnu99 -ffreestanding -O2 -Wall -Wextra"}


def build():
    clean()
    fnames = []
    os.makedirs(build_dir)
    # Build
    for src in os.listdir(src_dir):
        src = src.split(".")
        name = ".".join(src[:-1])
        if (src[-1] == "asm"):
            subprocess.run("nasm -felf64 {0}/{2}.asm"
                           " -o {1}/{2}.o".format(src_dir, build_dir, name),
                           shell=True, check=True)
            print("Assembled " + name)
        elif (src[-1] == "c"):
            subprocess.run("gcc -c {0}/{2}.c -o {1}/{2}.o {3}"
                           .format(src_dir, build_dir, name, flags[name]),
                           shell=True, check=True)
            print("Compiled " + name)
        else:
            continue
        fnames.append(build_dir + "/" + name + ".o")
    # Link
    subprocess.run("ld -n -o ./build/kernel.bin -T {0}/linker.ld {2}"
                   .format(src_dir, build_dir, " ".join(fnames)),
                   shell=True, check=True)


def run():
    os.makedirs(iso_dir + "/boot/grub")
    shutil.copy(src_dir + "/grub.cfg", iso_dir + "/boot/grub/grub.cfg")
    shutil.copy("./build/kernel.bin", iso_dir + "/boot/kernel.bin")
    subprocess.run("grub-mkrescue -o ./build/{0}.iso {1}"
                   .format(os_name, iso_dir), shell=True, check=True)
    shutil.rmtree(iso_dir)
    subprocess.run("qemu-system-x86_64 -cdrom ./build/{}.iso".format(os_name),
                   shell=True, check=True)


def clean():
    if os.path.exists("./build/"):
        shutil.rmtree("./build/")


parser = argparse.ArgumentParser()
parser.add_argument('--build', action="store_true", help="Builds the project.")
parser.add_argument('--run', action="store_true",
                    help="Invokes QEMU and runs the project.")
parser.add_argument('--clean', action="store_true",
                    help="Deletes compiled files")
args = parser.parse_args()

if args.build:
    build()
elif args.run:
    run()
elif args.clean:
    clean()
