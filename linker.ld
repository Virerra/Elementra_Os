ENTRY(start)

SECTIONS
{
  . = 0x100000;  /* Start at 1MB */

  .text :
  {
    *(.text)
  }

  .rodata :
  {
    *(.rodata)
  }

  .data :
  {
    *(.data)
  }

  .bss :
  {
    *(.bss)
  }
}
