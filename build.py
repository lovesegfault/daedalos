import argparse
import os
import shutil
import subprocess


arch = "x86_64"
foo = 1


def build():
    clean()
    os.makedirs("./build/arch/{}".format(arch))
    for src in os.listdir("./src/arch/{}".format(arch)):
        if (src.split(".")[-1] == "asm"):
            subprocess.run(["nasm", "-felf64", "./src/arch/{}/{}".format(arch, src), "-o", "./build/arch/{}/{}.o".format(arch,src)])
            print(src)
        # print(srcfile)


def run():
    os.makedirs("./build/isofiles/boot/grub")


def clean():
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
