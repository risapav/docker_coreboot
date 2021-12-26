Lenovo T410
===========

### Prep work
A flashrom binary dump of the stock T410 BIOS is needed to compile Coreboot.

* Place a copy of this dump under the T410 `stock_bios` directory and name it `stock_bios.bin` (to put it another way `./t410/stock_bios/stock_bios.bin`)

### Compiling
Build the latest merged into the master git branch:  
`./build.sh --bleeding-edge t410`

Latest stable release:  
 `./build.sh t410`

### Output

`coreboot_lenovo-t410-complete.rom` - The complete Coreboot ROM is the 8MB version used for internal or external flashing.   
`coreboot_lenovo-t410-complete.rom.sha256` - sha256 checksum of 8MB Coreboot Rom

## My target 

I would like to make bios for t410

config is neccessary copy into build dir and rename to .config

payload tianocore

build script:
	`./build.sh  -t 4.15 -i t410`