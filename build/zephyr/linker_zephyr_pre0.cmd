 OUTPUT_ARCH("riscv")
 OUTPUT_FORMAT("elf32-littleriscv")
       
user_iram_end = (0x3fccae00 + 0x700000);
user_iram_seg_org = ((1070071808) + 0x700000);
user_dram_seg_org = (1070071808);
user_dram_end = (user_iram_end - 0x700000);
user_idram_size = (user_dram_end - user_dram_seg_org);
user_iram_seg_len = user_idram_size;
user_dram_seg_len = user_idram_size;
MEMORY
{
  FLASH (R): org = 0x0, len = 4194304 - 0x100
  iram0_0_seg(RX): org = user_iram_seg_org, len = user_iram_seg_len
  dram0_0_seg(RW): org = user_dram_seg_org, len = user_dram_seg_len
  irom0_0_seg(RX): org = 0x42000000, len = 4194304
  drom0_0_seg (R): org = 0x3c000000, len = 4194304
  rtc_iram_seg(RWX): org = 0x50000000, len = 0x2000
  IDT_LIST(RW): org = 0x3ebfe010, len = 0x2000
}
REGION_ALIAS("rtc_slow_seg", rtc_iram_seg);
ENTRY("__start")
_rom_store_table = 0;
_iram_dram_offset = 0x700000;
_heap_sentry = 0x3fccc000;
SECTIONS
{
  iram_vma = ADDR(.iram0.text);
  iram_lma = LOADADDR(.iram0.text);
  iram_size_field = LOADADDR(.iram0.data) - LOADADDR(.iram0.text);
  dram_vma = ADDR(.dram0.data);
  dram_lma = LOADADDR(.dram0.data);
  dram_size_field = LOADADDR(.dram0.end) - LOADADDR(.dram0.data);
 .rel.plt : ALIGN_WITH_INPUT
 {
 *(.rel.plt)
 PROVIDE_HIDDEN (__rel_iplt_start = .);
 *(.rel.iplt)
 PROVIDE_HIDDEN (__rel_iplt_end = .);
 }
 .rela.plt : ALIGN_WITH_INPUT
 {
 *(.rela.plt)
 PROVIDE_HIDDEN (__rela_iplt_start = .);
 *(.rela.iplt)
 PROVIDE_HIDDEN (__rela_iplt_end = .);
 }
 .rel.dyn : ALIGN_WITH_INPUT
 {
 *(.rel.*)
 }
 .rela.dyn : ALIGN_WITH_INPUT
 {
 *(.rela.*)
 }
  .rtc.text :
  {
    . = ALIGN(4);
    *(.rtc.literal .rtc.text)
    *rtc_wake_stub*.o(.literal .text .literal.* .text.*)
  } > rtc_iram_seg AT > FLASH
  .rtc.dummy (NOLOAD):
  {
    . = SIZEOF(.rtc.text);
  } > rtc_iram_seg
  .rtc.data :
  {
    _rtc_data_start = ABSOLUTE(.);
    *(.rtc.data)
    *(.rtc.rodata)
    *rtc_wake_stub*.o(.data .rodata .data.* .rodata.* .bss .bss.*)
    _rtc_data_end = ABSOLUTE(.);
  } > rtc_iram_seg AT > FLASH
  .rtc.bss (NOLOAD) :
  {
    _rtc_bss_start = ABSOLUTE(.);
    *rtc_wake_stub*.o(.bss .bss.*)
    *rtc_wake_stub*.o(COMMON)
    _rtc_bss_end = ABSOLUTE(.);
  } > rtc_iram_seg
  .rtc.force_slow :
  {
    . = ALIGN(4);
    _rtc_force_slow_start = ABSOLUTE(.);
    *(.rtc.force_slow .rtc.force_slow.*)
    . = ALIGN(4) ;
    _rtc_force_slow_end = ABSOLUTE(.);
  } > rtc_slow_seg
  _rtc_slow_length = (_rtc_force_slow_end - _rtc_data_start);
  .iram0.text : ALIGN(4)
  {
    _iram_start = ABSOLUTE(.);
    _init_start = ABSOLUTE(.);
    KEEP(*(.exception_vectors.text));
    . = ALIGN(256);
    _invalid_pc_placeholder = ABSOLUTE(.);
    KEEP(*(.exception.entry*));
    *(.exception.other*)
    . = ALIGN(4);
    *(.entry.text)
    *(.init.literal)
    *(.init)
    . = ALIGN(4);
    _init_end = ABSOLUTE(.);
    _iram_text_start = ABSOLUTE(.);
    *(.iram1 .iram1.*)
    *(.iram0.literal .iram.literal .iram.text.literal .iram0.text .iram.text)
    *libzephyr.a:panic.*(.literal .text .literal.* .text.*)
    *libzephyr.a:loader.*(.literal .text .literal.* .text.*)
    *libzephyr.a:flash_init.*(.literal .text .literal.* .text.*)
    *libzephyr.a:soc_flash_init.*(.literal .text .literal.* .text.*)
    *libzephyr.a:console_init.*(.literal .text .literal.* .text.*)
    *libzephyr.a:soc_init.*(.literal .text .literal.* .text.*)
    *libzephyr.a:hw_init.*(.literal .text .literal.* .text.*)
    *libzephyr.a:soc_random.*(.literal .text .literal.* .text.*)
    *libarch__riscv__core.a:(.literal .text .literal.* .text.*)
    *libsubsys__net__l2__ethernet.a:(.literal .text .literal.* .text.*)
    *libsubsys__net__lib__config.a:(.literal .text .literal.* .text.*)
    *libsubsys__net__ip.a:(.literal .text .literal.* .text.*)
    *libsubsys__net.a:(.literal .text .literal.* .text.*)
    *libkernel.a:(.literal .text .literal.* .text.*)
    *libgcc.a:lib2funcs.*(.literal .text .literal.* .text.*)
    *libdrivers__flash.a:flash_esp32.*(.literal .text .literal.* .text.*)
    *libzephyr.a:log_noos.*(.literal .text .literal.* .text.*)
    *libdrivers__timer.a:esp32c3_sys_timer.*(.literal .text .literal.* .text.*)
    *libzephyr.a:log_core.*(.literal .text .literal.* .text.*)
    *libzephyr.a:cbprintf_complete.*(.literal .text .literal.* .text.*)
    *libzephyr.a:printk.*(.literal.printk .literal.vprintk .literal.char_out .text.printk .text.vprintk .text.char_out)
    *libzephyr.a:log_msg.*(.literal .text .literal.* .text.*)
    *libzephyr.a:log_list.*(.literal .text .literal.* .text.*)
    *libdrivers__console.a:uart_console.*(.literal.console_out .text.console_out)
    *libzephyr.a:log_output.*(.literal .text .literal.* .text.*)
    *libzephyr.a:log_backend_uart.*(.literal .text .literal.* .text.*)
    *libzephyr.a:rtc_*.*(.literal .text .literal.* .text.*)
    *liblib__libc__newlib.a:string.*(.literal .text .literal.* .text.*)
    *liblib__libc__minimal.a:string.*(.literal .text .literal.* .text.*)
    *liblib__libc__picolib.a:string.*(.literal .text .literal.* .text.*)
    *libzephyr.a:periph_ctrl.*(.literal .text .literal.* .text.*)
    *libgcov.a:(.literal .text .literal.* .text.*)
    *libphy.a:( .phyiram .phyiram.*)
    *libc.a:*(.literal .text .literal.* .text.*)
    *libzephyr.a:mmu_hal.*(.literal .text .literal.* .text.*)
    *libzephyr.a:spi_flash_hal_iram.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_encrypt_hal_iram.*(.literal .text .literal.* .text.*)
    *libzephyr.a:cache_hal.*(.literal .text .literal.* .text.*)
    *libzephyr.a:ledc_hal_iram.*(.literal .text .literal.* .text.*)
    *libzephyr.a:i2c_hal_iram.*(.literal .text .literal.* .text.*)
    *libzephyr.a:wdt_hal_iram.*(.literal .text .literal.* .text.*)
    *libzephyr.a:systimer_hal.*(.literal .text .literal.* .text.*)
    *libzephyr.a:spi_flash_hal_gpspi.*(.literal .literal.* .text .text.*)
    *libzephyr.a:lldesc.*(.literal .literal.* .text .text.*)
    *(.literal.esp_log_write .text.esp_log_write)
    *(.literal.esp_log_timestamp .text.esp_log_timestamp)
    *(.literal.esp_log_early_timestamp .text.esp_log_early_timestamp)
    *(.literal.esp_log_impl_lock .text.esp_log_impl_lock)
    *(.literal.esp_log_impl_lock_timeout .text.esp_log_impl_lock_timeout)
    *(.literal.esp_log_impl_unlock .text.esp_log_impl_unlock)
    *libzephyr.a:spi_flash_chip_boya.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_chip_gd.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_chip_generic.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_chip_issi.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_chip_mxic.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_chip_mxic_opi.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_chip_th.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_chip_winbond.*(.literal .literal.* .text .text.*)
    *libzephyr.a:memspi_host_driver.*(.literal .literal.* .text .text.*)
    *libzephyr.a:flash_brownout_hook.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_wrap.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_hpm_enable.*(.literal .literal.* .text .text.*)
    *libzephyr.a:flash_ops.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_err.*(.literal .literal.* .text .text.*)
    *(.literal.esp_system_abort .text.esp_system_abort)
    *(.literal.esp_cpu_stall .text.esp_cpu_stall)
    *(.literal.esp_cpu_unstall .text.esp_cpu_unstall)
    *(.literal.esp_cpu_reset .text.esp_cpu_reset)
    *(.literal.esp_cpu_wait_for_intr .text.esp_cpu_wait_for_intr)
    *(.literal.esp_cpu_compare_and_set .text.esp_cpu_compare_and_set)
    *(.literal.esp_gpio_reserve_pins .text.esp_gpio_reserve_pins)
    *(.literal.esp_gpio_is_pin_reserved .text.esp_gpio_is_pin_reserved)
    *(.literal.rtc_vddsdio_get_config .text.rtc_vddsdio_get_config)
    *(.literal.rtc_vddsdio_set_config .text.rtc_vddsdio_set_config)
    *libzephyr.a:esp_memory_utils.*(.literal .literal.* .text .text.*)
    *libzephyr.a:rtc_clk.*(.literal .literal.* .text .text.*)
    *libzephyr.a:rtc_clk_init.*(.literal .literal.* .text .text.*)
    *libzephyr.a:rtc_time.*(.literal .literal.* .text .text.*)
    *libzephyr.a:rtc_sleep.*(.literal .literal.* .text .text.*)
    *libzephyr.a:systimer.*(.literal .literal.* .text .text.*)
    *libzephyr.a:mspi_timing_config.*(.literal .literal.* .text .text.*)
    *libzephyr.a:mspi_timing_tuning.*(.literal .literal.* .text .text.*)
    *(.literal.sar_periph_ctrl_power_enable .text.sar_periph_ctrl_power_enable)
    *(.literal.GPIO_HOLD_MASK .text.GPIO_HOLD_MASK)
    *libzephyr.a:esp_rom_spiflash.*(.literal .literal.* .text .text.*)
    *libzephyr.a:esp_rom_systimer.*(.literal .literal.* .text .text.*)
    *libzephyr.a:esp_rom_wdt.*(.literal .literal.* .text .text.*)
    *libzephyr.a:esp_cache.*(.literal .literal.* .text .text.*)
    *libzephyr.a:cache_utils.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_random*.*(.literal.bootloader_random_disable .text.bootloader_random_disable)
    *libzephyr.a:bootloader_random*.*(.literal.bootloader_random_enable .text.bootloader_random_enable)
    *libnet80211.a:( .wifi0iram .wifi0iram.* .wifislpiram .wifislpiram.* .wifiextrairam .wifiextrairam.*)
    *libpp.a:( .wifi0iram .wifi0iram.* .wifislpiram .wifislpiram.* .wifiextrairam .wifiextrairam.*)
    *libcoexist.a:(.wifi_slp_iram .wifi_slp_iram.*)
    *(.literal.wifi_clock_enable_wrapper .text.wifi_clock_enable_wrapper)
    *(.literal.wifi_clock_disable_wrapper .text.wifi_clock_disable_wrapper)
    *(.literal.esp_phy_enable .text.esp_phy_enable)
    *(.literal.esp_phy_disable .text.esp_phy_disable)
    *(.literal.esp_wifi_bt_power_domain_off .text.esp_wifi_bt_power_domain_off)
    . = ALIGN(4) + 16;
  } > iram0_0_seg AT > FLASH
  .loader.text :
  {
    . = ALIGN(4);
    _loader_text_start = ABSOLUTE(.);
    *libzephyr.a:bootloader_clock_init.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_wdt.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_flash.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_clock_loader.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_panic.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_random.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_efuse.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_utility.*(.literal .text .literal.* .text.*)
    *libzephyr.a:bootloader_sha.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_image_format.*(.literal .text .literal.* .text.*)
    *libzephyr.a:flash_encrypt.*(.literal .text .literal.* .text.*)
    *libzephyr.a:flash_encryption_secure_features.*(.literal .text .literal.* .text.*)
    *libzephyr.a:flash_partitions.*(.literal .text .literal.* .text.*)
    *libzephyr.a:flash_qio_mode.*(.literal .text .literal.* .text.*)
    *libzephyr.a:spi_flash_hal.*(.literal .literal.* .text .text.*)
    *libzephyr.a:spi_flash_hal_common.*(.literal .literal.* .text .text.*)
    *libzephyr.a:esp_flash_api.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_flash_spi_init.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_efuse_table.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_efuse_fields.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_efuse_api.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_efuse_utility.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_efuse_api_key_esp32xx.*(.literal .text .literal.* .text.*)
    *libzephyr.a:secure_boot.*(.literal .text .literal.* .text.*)
    *libzephyr.a:secure_boot_secure_features.*(.literal .text .literal.* .text.*)
    *libzephyr.a:secure_boot_signatures_bootloader.*(.literal .text .literal.* .text.*)
    *libzephyr.a:cpu_region_protect.*(.literal .text .literal.* .text.*)
    *libzephyr.a:esp_gpio_reserve.*(.literal .text .literal.* .text.*)
    . = ALIGN(0x10) + 0x10;
    _loader_text_end = ABSOLUTE(.);
  } > iram0_0_seg AT > FLASH
  .iram0.text_end (NOLOAD) :
  {
    . = ALIGN (16);
    _iram_text_end = ABSOLUTE(.);
  } > iram0_0_seg
  .iram0.data :
  {
    . = ALIGN(16);
    *(.iram.data)
    *(.iram.data*)
  } > iram0_0_seg AT > FLASH
  .iram0.bss (NOLOAD) :
  {
    . = ALIGN(16);
    *(.iram.bss)
    *(.iram.bss*)
    . = ALIGN(16);
    _iram_end = ABSOLUTE(.);
  } > iram0_0_seg
  .dram0.dummy (NOLOAD):
  {
    . = ORIGIN(dram0_0_seg) + MAX(_iram_end, user_iram_seg_org) - user_iram_seg_org;
    . = ALIGN(16) + 16;
  } > dram0_0_seg
  .dram0.data :
  {
    . = ALIGN(4);
    _data_start = ABSOLUTE(.);
    __data_start = ABSOLUTE(.);
    *(.data)
    *(.data.*)
    *(.gnu.linkonce.d.*)
    *(.data1)
    . = ALIGN(8);
    __global_pointer$ = . + 0x800;
    *(.sdata)
    *(.sdata.*)
    *(.gnu.linkonce.s.*)
    *(.sdata2)
    *(.sdata2.*)
    *(.gnu.linkonce.s2.*)
    *libkernel.a:fatal.*(.rodata .rodata.* .srodata .srodata.*)
    *libkernel.a:init.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:cbprintf_complete*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:log_core.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:log_backend_uart.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:log_output.*(.rodata .rodata.* .srodata .srodata.*)
    *libdrivers__flash.a:flash_esp32.*(.rodata .rodata.* .srodata .srodata.*)
    *libdrivers__serial.a:uart_esp32.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:periph_ctrl.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:loader.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:flash_init.*(.rodata .rodata.*)
    *libzephyr.a:soc_flash_init.*(.rodata .rodata.*)
    *libzephyr.a:console_init.*(.rodata .rodata.*)
    *libzephyr.a:soc_init.*(.rodata .rodata.*)
    *libzephyr.a:hw_init.*(.rodata .rodata.*)
    *libzephyr.a:soc_random.*(.rodata .rodata.*)
    *libzephyr.a:cache_utils.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:mmu_hal.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_hal_iram.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_encrypt_hal_iram.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:cache_hal.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:ledc_hal_iram.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:i2c_hal_iram.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:wdt_hal_iram.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:systimer_hal.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_hal_gpspi.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:lldesc.*(.rodata .rodata.* .srodata .srodata.*)
    *(.rodata.esp_log_write)
    *(.rodata.esp_log_timestamp)
    *(.rodata.esp_log_early_timestamp)
    *(.rodata.esp_log_impl_lock)
    *(.rodata.esp_log_impl_lock_timeout)
    *(.rodata.esp_log_impl_unlock)
    *libzephyr.a:spi_flash_chip_boya.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_chip_gd.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_chip_generic.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_chip_issi.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_chip_mxic.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_chip_mxic_opi.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_chip_th.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_chip_winbond.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:memspi_host_driver.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:flash_brownout_hook.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_wrap.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_hpm_enable.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:flash_ops.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:flash_qio_mode.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:esp_cache.*(.rodata .rodata.* .srodata .srodata.*)
    *(.rodata.esp_cpu_stall)
    *(.rodata.esp_cpu_unstall)
    *(.rodata.esp_cpu_reset)
    *(.rodata.esp_cpu_wait_for_intr)
    *(.rodata.esp_cpu_compare_and_set)
    *(.rodata.esp_gpio_reserve_pins)
    *(.rodata.esp_gpio_is_pin_reserved)
    *(.rodata.rtc_vddsdio_get_config)
    *(.rodata.rtc_vddsdio_set_config)
    *libzephyr.a:esp_memory_utils.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:rtc_clk.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:rtc_clk_init.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:systimer.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:mspi_timing_config.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:mspi_timing_tuning.*(.rodata .rodata.* .srodata .srodata.*)
    *(.rodata.sar_periph_ctrl_power_enable)
    *libzephyr.a:esp_err.*(.rodata .rodata.*)
    *(.rodata.esp_system_abort)
    . = ALIGN(4);
    . = ALIGN(4);
    KEEP(*(.jcr))
    *(.dram1 .dram1.*)
    . = ALIGN(4);
  } > dram0_0_seg AT > FLASH
  .loader.data :
  {
    . = ALIGN(4);
    _loader_data_start = ABSOLUTE(.);
    *libzephyr.a:bootloader_clock_init.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:bootloader_wdt.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:bootloader_flash.*(.srodata .srodata.* .rodata .rodata.*)
    *libzephyr.a:bootloader_clock_loader.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:bootloader_panic.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:cpu_region_protect.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:clk.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:esp_clk.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:flash_mmap.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:flash_ops.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:esp_gpio_reserve.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_hal.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:spi_flash_hal_common.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:esp_flash_api.*(.rodata .rodata.* .srodata .srodata.*)
    *libzephyr.a:esp_flash_spi_init.*(.rodata .rodata.* .srodata .srodata.*)
    . = ALIGN(16);
    _loader_data_end = ABSOLUTE(.);
  } > dram0_0_seg AT > FLASH
 sw_isr_table : ALIGN_WITH_INPUT
 {
  . = ALIGN(4);
  *(.gnu.linkonce.sw_isr_table*)
 } > dram0_0_seg AT > FLASH
        device_states : ALIGN_WITH_INPUT
        {
                __device_states_start = .;
  KEEP(*(".z_devstate"));
  KEEP(*(".z_devstate.*"));
                __device_states_end = .;
        } > dram0_0_seg AT > FLASH
 log_mpsc_pbuf_area : ALIGN_WITH_INPUT { _log_mpsc_pbuf_list_start = .; *(SORT_BY_NAME(._log_mpsc_pbuf.static.*)); _log_mpsc_pbuf_list_end = .; } > dram0_0_seg AT > FLASH
 log_msg_ptr_area : ALIGN_WITH_INPUT { _log_msg_ptr_list_start = .; KEEP(*(SORT_BY_NAME(._log_msg_ptr.static.*))); _log_msg_ptr_list_end = .; } > dram0_0_seg AT > FLASH
 log_dynamic_area : ALIGN_WITH_INPUT { _log_dynamic_list_start = .; KEEP(*(SORT_BY_NAME(._log_dynamic.static.*))); _log_dynamic_list_end = .; } > dram0_0_seg AT > FLASH
 k_timer_area : ALIGN_WITH_INPUT { _k_timer_list_start = .; *(SORT_BY_NAME(._k_timer.static.*)); _k_timer_list_end = .; } > dram0_0_seg AT > FLASH
 k_mem_slab_area : ALIGN_WITH_INPUT { _k_mem_slab_list_start = .; *(SORT_BY_NAME(._k_mem_slab.static.*)); _k_mem_slab_list_end = .; } > dram0_0_seg AT > FLASH
 k_heap_area : ALIGN_WITH_INPUT { _k_heap_list_start = .; *(SORT_BY_NAME(._k_heap.static.*)); _k_heap_list_end = .; } > dram0_0_seg AT > FLASH
 k_mutex_area : ALIGN_WITH_INPUT { _k_mutex_list_start = .; *(SORT_BY_NAME(._k_mutex.static.*)); _k_mutex_list_end = .; } > dram0_0_seg AT > FLASH
 k_stack_area : ALIGN_WITH_INPUT { _k_stack_list_start = .; *(SORT_BY_NAME(._k_stack.static.*)); _k_stack_list_end = .; } > dram0_0_seg AT > FLASH
 k_msgq_area : ALIGN_WITH_INPUT { _k_msgq_list_start = .; *(SORT_BY_NAME(._k_msgq.static.*)); _k_msgq_list_end = .; } > dram0_0_seg AT > FLASH
 k_mbox_area : ALIGN_WITH_INPUT { _k_mbox_list_start = .; *(SORT_BY_NAME(._k_mbox.static.*)); _k_mbox_list_end = .; } > dram0_0_seg AT > FLASH
 k_pipe_area : ALIGN_WITH_INPUT { _k_pipe_list_start = .; *(SORT_BY_NAME(._k_pipe.static.*)); _k_pipe_list_end = .; } > dram0_0_seg AT > FLASH
 k_sem_area : ALIGN_WITH_INPUT { _k_sem_list_start = .; *(SORT_BY_NAME(._k_sem.static.*)); _k_sem_list_end = .; } > dram0_0_seg AT > FLASH
 k_event_area : ALIGN_WITH_INPUT { _k_event_list_start = .; *(SORT_BY_NAME(._k_event.static.*)); _k_event_list_end = .; } > dram0_0_seg AT > FLASH
 k_queue_area : ALIGN_WITH_INPUT { _k_queue_list_start = .; *(SORT_BY_NAME(._k_queue.static.*)); _k_queue_list_end = .; } > dram0_0_seg AT > FLASH
 k_fifo_area : ALIGN_WITH_INPUT { _k_fifo_list_start = .; *(SORT_BY_NAME(._k_fifo.static.*)); _k_fifo_list_end = .; } > dram0_0_seg AT > FLASH
 k_lifo_area : ALIGN_WITH_INPUT { _k_lifo_list_start = .; *(SORT_BY_NAME(._k_lifo.static.*)); _k_lifo_list_end = .; } > dram0_0_seg AT > FLASH
 k_condvar_area : ALIGN_WITH_INPUT { _k_condvar_list_start = .; *(SORT_BY_NAME(._k_condvar.static.*)); _k_condvar_list_end = .; } > dram0_0_seg AT > FLASH
 sys_mem_blocks_ptr_area : ALIGN_WITH_INPUT { _sys_mem_blocks_ptr_list_start = .; *(SORT_BY_NAME(._sys_mem_blocks_ptr.static.*)); _sys_mem_blocks_ptr_list_end = .; } > dram0_0_seg AT > FLASH
 net_buf_pool_area : ALIGN_WITH_INPUT { _net_buf_pool_list_start = .; KEEP(*(SORT_BY_NAME(._net_buf_pool.static.*))); _net_buf_pool_list_end = .; } > dram0_0_seg AT > FLASH
 net_if_area : ALIGN_WITH_INPUT { _net_if_list_start = .; KEEP(*(SORT_BY_NAME(._net_if.static.*))); _net_if_list_end = .; } > dram0_0_seg AT > FLASH net_if_dev_area : ALIGN_WITH_INPUT { _net_if_dev_list_start = .; KEEP(*(SORT_BY_NAME(._net_if_dev.static.*))); _net_if_dev_list_end = .; } > dram0_0_seg AT > FLASH net_l2_area : ALIGN_WITH_INPUT { _net_l2_list_start = .; KEEP(*(SORT_BY_NAME(._net_l2.static.*))); _net_l2_list_end = .; } > dram0_0_seg AT > FLASH eth_bridge_area : ALIGN_WITH_INPUT { _eth_bridge_list_start = .; KEEP(*(SORT_BY_NAME(._eth_bridge.static.*))); _eth_bridge_list_end = .; } > dram0_0_seg AT > FLASH
         
 log_strings_area : ALIGN_WITH_INPUT { _log_strings_list_start = .; KEEP(*(SORT_BY_NAME(._log_strings.static.*))); _log_strings_list_end = .; } > dram0_0_seg AT > FLASH
 log_stmesp_ptr_area : ALIGN_WITH_INPUT { _log_stmesp_ptr_list_start = .; KEEP(*(SORT_BY_NAME(._log_stmesp_ptr.static.*))); _log_stmesp_ptr_list_end = .; } > dram0_0_seg AT > FLASH
 log_stmesp_str_area : ALIGN_WITH_INPUT { _log_stmesp_str_list_start = .; KEEP(*(SORT_BY_NAME(._log_stmesp_str.static.*))); _log_stmesp_str_list_end = .; } > dram0_0_seg AT > FLASH
 log_const_area : ALIGN_WITH_INPUT { _log_const_list_start = .; KEEP(*(SORT_BY_NAME(._log_const.static.*))); _log_const_list_end = .; } > dram0_0_seg AT > FLASH
 log_backend_area : ALIGN_WITH_INPUT { _log_backend_list_start = .; KEEP(*(SORT_BY_NAME(._log_backend.static.*))); _log_backend_list_end = .; } > dram0_0_seg AT > FLASH
 log_link_area : ALIGN_WITH_INPUT { _log_link_list_start = .; KEEP(*(SORT_BY_NAME(._log_link.static.*))); _log_link_list_end = .; } > dram0_0_seg AT > FLASH
         
  .dram0.end :
  {
    . = ALIGN(4);
    _data_end = ABSOLUTE(.);
    __data_end = ABSOLUTE(.);
  } > dram0_0_seg AT > FLASH
  .dram0.noinit (NOLOAD):
  {
    . = ALIGN(4);
    *(.noinit)
    *(.noinit.*)
    . = ALIGN(4);
  } > dram0_0_seg
  .dram0.bss (NOLOAD) :
  {
    . = ALIGN (8);
    __bss_start = ABSOLUTE(.);
    _bss_start = ABSOLUTE(.);
    _btdm_bss_start = ABSOLUTE(.);
    *libbtdm_app.a:(.bss .bss.* COMMON)
    . = ALIGN (4);
    _btdm_bss_end = ABSOLUTE(.);
    *(.dynsbss)
    *(.sbss)
    *(.sbss.*)
    *(.gnu.linkonce.sb.*)
    *(.scommon)
    *(.sbss2)
    *(.sbss2.*)
    *(.gnu.linkonce.sb2.*)
    *(.dynbss)
    *(.bss)
    *(.bss.*)
    *(.share.mem)
    *(.gnu.linkonce.b.*)
    *(COMMON)
    . = ALIGN (16);
    __bss_end = ABSOLUTE(.);
    _bss_end = ABSOLUTE(.);
  } > dram0_0_seg
  _image_ram_start = _iram_start - 0x700000;
    .last_ram_section (NOLOAD) : ALIGN_WITH_INPUT
    {
 _image_ram_end = .;
 _image_ram_size = _image_ram_end - _image_ram_start;
 _end = .;
 z_mapped_end = .;
    } > dram0_0_seg
  ASSERT(((_end - ORIGIN(dram0_0_seg)) <= LENGTH(dram0_0_seg)), "SRAM instruction/data does not fit.")
  .flash.text_dummy (NOLOAD):
  {
    . = ALIGN(0x10000);
  } > FLASH
  _image_irom_start = LOADADDR(.flash.text);
  _image_irom_size = SIZEOF(.flash.text);
  _image_irom_vaddr = ADDR(.flash.text);
  .flash.text : ALIGN(0x10000)
  {
    _stext = .;
    _instruction_reserved_start = ABSOLUTE(.);
    _text_start = ABSOLUTE(.);
    _instruction_reserved_start = ABSOLUTE(.);
    __text_region_start = ABSOLUTE(.);
    __rom_region_start = ABSOLUTE(.);
    *libnet80211.a:( .wifirxiram .wifirxiram.* .wifislprxiram .wifislprxiram.*)
    *libpp.a:( .wifirxiram .wifirxiram.* .wifislprxiram .wifislprxiram.*)
    *(.literal .text .literal.* .text.*)
    *(.stub .gnu.warning .gnu.linkonce.literal.* .gnu.linkonce.t.*.literal .gnu.linkonce.t.*)
    *(.irom0.text)
    *(.fini.literal)
    *(.fini)
    *(.gnu.version)
    . += 16;
    _instruction_reserved_end = ABSOLUTE(.);
    _text_end = ABSOLUTE(.);
    _instruction_reserved_end = ABSOLUTE(.);
    __text_region_end = ABSOLUTE(.);
    __rom_region_end = ABSOLUTE(.);
    _etext = .;
  } > irom0_0_seg AT > FLASH
  .flash.dummy (NOLOAD) :
  {
    . = ALIGN(0x10000);
  } > FLASH
  .flash.rodata_dummy (NOLOAD) :
  {
    . += SIZEOF(.flash.text);
    . = ALIGN(0x10000);
  } > drom0_0_seg
  _image_drom_start = LOADADDR(.flash.rodata);
  _image_drom_size = _image_rodata_end - _image_rodata_start;
  _image_drom_vaddr = ADDR(.flash.rodata);
  .flash.rodata : ALIGN(0x10)
  {
    _rodata_reserved_start = ABSOLUTE(.);
    _image_rodata_start = ABSOLUTE(.);
    *(.rodata_desc .rodata_desc.*)
    *(.rodata_custom_desc .rodata_custom_desc.*)
    __rodata_region_start = ABSOLUTE(.);
    . = ALIGN(4);
    *(.irom1.text)
    *(.gnu.linkonce.r.*)
    *(.rodata1)
    __XT_EXCEPTION_TABLE_ = ABSOLUTE(.);
    *(.xt_except_table)
    *(.gcc_except_table .gcc_except_table.*)
    *(.gnu.linkonce.e.*)
    *(.gnu.version_r)
    . = (. + 3) & ~ 3;
    __eh_frame = ABSOLUTE(.);
    KEEP(*(.eh_frame))
    . = (. + 7) & ~ 3;
    __XT_EXCEPTION_DESCS_ = ABSOLUTE(.);
    *(.xt_except_desc)
    *(.gnu.linkonce.h.*)
    __XT_EXCEPTION_DESCS_END__ = ABSOLUTE(.);
    *(.xt_except_desc_end)
    *(.dynamic)
    *(.gnu.version_d)
    __rodata_region_end = ABSOLUTE(.);
    _rodata_end = ABSOLUTE(.);
    _lit4_start = ABSOLUTE(.);
    *(*.lit4)
    *(.lit4.*)
    *(.gnu.linkonce.lit4.*)
    _lit4_end = ABSOLUTE(.);
    . = ALIGN(4);
    *(.srodata)
    *(.srodata.*)
    *(.rodata)
    *(.rodata.*)
    *(.rodata_wlog)
    *(.rodata_wlog*)
    . = ALIGN(4);
  } > drom0_0_seg AT > FLASH
 init_array : ALIGN_WITH_INPUT
 {
  KEEP(*(SORT_BY_NAME(".ctors*")))
  KEEP(*(SORT_BY_NAME(".init_array*")))
 } > drom0_0_seg AT > FLASH
 ASSERT (SIZEOF(init_array) == 0,
  "GNU-style constructors required but STATIC_INIT_GNU not enabled")
 initlevel : ALIGN_WITH_INPUT
 {
  __init_start = .;
  __init_EARLY_start = .; KEEP(*(SORT(.z_init_EARLY?_*))); KEEP(*(SORT(.z_init_EARLY??_*)));
  __init_PRE_KERNEL_1_start = .; KEEP(*(SORT(.z_init_PRE_KERNEL_1?_*))); KEEP(*(SORT(.z_init_PRE_KERNEL_1??_*)));
  __init_PRE_KERNEL_2_start = .; KEEP(*(SORT(.z_init_PRE_KERNEL_2?_*))); KEEP(*(SORT(.z_init_PRE_KERNEL_2??_*)));
  __init_POST_KERNEL_start = .; KEEP(*(SORT(.z_init_POST_KERNEL?_*))); KEEP(*(SORT(.z_init_POST_KERNEL??_*)));
  __init_APPLICATION_start = .; KEEP(*(SORT(.z_init_APPLICATION?_*))); KEEP(*(SORT(.z_init_APPLICATION??_*)));
  __init_SMP_start = .; KEEP(*(SORT(.z_init_SMP?_*))); KEEP(*(SORT(.z_init_SMP??_*)));
  __init_end = .;
  __deferred_init_list_start = .;
  KEEP(*(.z_deferred_init*))
  __deferred_init_list_end = .;
 } > drom0_0_seg AT > FLASH
 device_area : ALIGN_WITH_INPUT { _device_list_start = .; KEEP(*(SORT(._device.static.*_?_*))); KEEP(*(SORT(._device.static.*_??_*))); _device_list_end = .; } > drom0_0_seg AT > FLASH
 initlevel_error : ALIGN_WITH_INPUT
 {
  KEEP(*(SORT(.z_init_[_A-Z0-9]*)))
 }
 ASSERT(SIZEOF(initlevel_error) == 0, "Undefined initialization levels used.")
 app_shmem_regions : ALIGN_WITH_INPUT
 {
  __app_shmem_regions_start = .;
  KEEP(*(SORT(.app_regions.*)));
  __app_shmem_regions_end = .;
 } > drom0_0_seg AT > FLASH
 k_p4wq_initparam_area : ALIGN_WITH_INPUT { _k_p4wq_initparam_list_start = .; KEEP(*(SORT_BY_NAME(._k_p4wq_initparam.static.*))); _k_p4wq_initparam_list_end = .; } > drom0_0_seg AT > FLASH
 _static_thread_data_area : ALIGN_WITH_INPUT { __static_thread_data_list_start = .; KEEP(*(SORT_BY_NAME(.__static_thread_data.static.*))); __static_thread_data_list_end = .; } > drom0_0_seg AT > FLASH
 device_deps : ALIGN_WITH_INPUT
 {
__device_deps_start = .;
KEEP(*(SORT(.__device_deps_pass2*)));
__device_deps_end = .;
 } > drom0_0_seg AT > FLASH
entropy_driver_api_area : ALIGN_WITH_INPUT { _entropy_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._entropy_driver_api.static.*))); _entropy_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
gpio_driver_api_area : ALIGN_WITH_INPUT { _gpio_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._gpio_driver_api.static.*))); _gpio_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
shared_irq_driver_api_area : ALIGN_WITH_INPUT { _shared_irq_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._shared_irq_driver_api.static.*))); _shared_irq_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
crypto_driver_api_area : ALIGN_WITH_INPUT { _crypto_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._crypto_driver_api.static.*))); _crypto_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
adc_driver_api_area : ALIGN_WITH_INPUT { _adc_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._adc_driver_api.static.*))); _adc_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
auxdisplay_driver_api_area : ALIGN_WITH_INPUT { _auxdisplay_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._auxdisplay_driver_api.static.*))); _auxdisplay_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
bbram_driver_api_area : ALIGN_WITH_INPUT { _bbram_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._bbram_driver_api.static.*))); _bbram_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
bt_hci_driver_api_area : ALIGN_WITH_INPUT { _bt_hci_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._bt_hci_driver_api.static.*))); _bt_hci_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
can_driver_api_area : ALIGN_WITH_INPUT { _can_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._can_driver_api.static.*))); _can_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
cellular_driver_api_area : ALIGN_WITH_INPUT { _cellular_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._cellular_driver_api.static.*))); _cellular_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
charger_driver_api_area : ALIGN_WITH_INPUT { _charger_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._charger_driver_api.static.*))); _charger_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
clock_control_driver_api_area : ALIGN_WITH_INPUT { _clock_control_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._clock_control_driver_api.static.*))); _clock_control_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
comparator_driver_api_area : ALIGN_WITH_INPUT { _comparator_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._comparator_driver_api.static.*))); _comparator_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
coredump_driver_api_area : ALIGN_WITH_INPUT { _coredump_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._coredump_driver_api.static.*))); _coredump_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
counter_driver_api_area : ALIGN_WITH_INPUT { _counter_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._counter_driver_api.static.*))); _counter_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
dac_driver_api_area : ALIGN_WITH_INPUT { _dac_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._dac_driver_api.static.*))); _dac_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
dai_driver_api_area : ALIGN_WITH_INPUT { _dai_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._dai_driver_api.static.*))); _dai_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
display_driver_api_area : ALIGN_WITH_INPUT { _display_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._display_driver_api.static.*))); _display_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
dma_driver_api_area : ALIGN_WITH_INPUT { _dma_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._dma_driver_api.static.*))); _dma_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
edac_driver_api_area : ALIGN_WITH_INPUT { _edac_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._edac_driver_api.static.*))); _edac_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
eeprom_driver_api_area : ALIGN_WITH_INPUT { _eeprom_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._eeprom_driver_api.static.*))); _eeprom_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
emul_bbram_driver_api_area : ALIGN_WITH_INPUT { _emul_bbram_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._emul_bbram_driver_api.static.*))); _emul_bbram_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
fuel_gauge_emul_driver_api_area : ALIGN_WITH_INPUT { _fuel_gauge_emul_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._fuel_gauge_emul_driver_api.static.*))); _fuel_gauge_emul_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
emul_sensor_driver_api_area : ALIGN_WITH_INPUT { _emul_sensor_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._emul_sensor_driver_api.static.*))); _emul_sensor_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
espi_driver_api_area : ALIGN_WITH_INPUT { _espi_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._espi_driver_api.static.*))); _espi_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
espi_saf_driver_api_area : ALIGN_WITH_INPUT { _espi_saf_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._espi_saf_driver_api.static.*))); _espi_saf_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
flash_driver_api_area : ALIGN_WITH_INPUT { _flash_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._flash_driver_api.static.*))); _flash_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
fpga_driver_api_area : ALIGN_WITH_INPUT { _fpga_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._fpga_driver_api.static.*))); _fpga_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
fuel_gauge_driver_api_area : ALIGN_WITH_INPUT { _fuel_gauge_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._fuel_gauge_driver_api.static.*))); _fuel_gauge_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
gnss_driver_api_area : ALIGN_WITH_INPUT { _gnss_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._gnss_driver_api.static.*))); _gnss_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
haptics_driver_api_area : ALIGN_WITH_INPUT { _haptics_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._haptics_driver_api.static.*))); _haptics_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
hwspinlock_driver_api_area : ALIGN_WITH_INPUT { _hwspinlock_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._hwspinlock_driver_api.static.*))); _hwspinlock_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
i2c_driver_api_area : ALIGN_WITH_INPUT { _i2c_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._i2c_driver_api.static.*))); _i2c_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
i2c_target_driver_api_area : ALIGN_WITH_INPUT { _i2c_target_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._i2c_target_driver_api.static.*))); _i2c_target_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
i2s_driver_api_area : ALIGN_WITH_INPUT { _i2s_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._i2s_driver_api.static.*))); _i2s_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
i3c_driver_api_area : ALIGN_WITH_INPUT { _i3c_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._i3c_driver_api.static.*))); _i3c_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
ipm_driver_api_area : ALIGN_WITH_INPUT { _ipm_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._ipm_driver_api.static.*))); _ipm_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
kscan_driver_api_area : ALIGN_WITH_INPUT { _kscan_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._kscan_driver_api.static.*))); _kscan_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
led_driver_api_area : ALIGN_WITH_INPUT { _led_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._led_driver_api.static.*))); _led_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
led_strip_driver_api_area : ALIGN_WITH_INPUT { _led_strip_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._led_strip_driver_api.static.*))); _led_strip_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
lora_driver_api_area : ALIGN_WITH_INPUT { _lora_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._lora_driver_api.static.*))); _lora_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
mbox_driver_api_area : ALIGN_WITH_INPUT { _mbox_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._mbox_driver_api.static.*))); _mbox_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
mdio_driver_api_area : ALIGN_WITH_INPUT { _mdio_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._mdio_driver_api.static.*))); _mdio_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
mipi_dbi_driver_api_area : ALIGN_WITH_INPUT { _mipi_dbi_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._mipi_dbi_driver_api.static.*))); _mipi_dbi_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
mipi_dsi_driver_api_area : ALIGN_WITH_INPUT { _mipi_dsi_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._mipi_dsi_driver_api.static.*))); _mipi_dsi_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
mspi_driver_api_area : ALIGN_WITH_INPUT { _mspi_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._mspi_driver_api.static.*))); _mspi_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
peci_driver_api_area : ALIGN_WITH_INPUT { _peci_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._peci_driver_api.static.*))); _peci_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
ps2_driver_api_area : ALIGN_WITH_INPUT { _ps2_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._ps2_driver_api.static.*))); _ps2_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
ptp_clock_driver_api_area : ALIGN_WITH_INPUT { _ptp_clock_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._ptp_clock_driver_api.static.*))); _ptp_clock_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
pwm_driver_api_area : ALIGN_WITH_INPUT { _pwm_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._pwm_driver_api.static.*))); _pwm_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
regulator_parent_driver_api_area : ALIGN_WITH_INPUT { _regulator_parent_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._regulator_parent_driver_api.static.*))); _regulator_parent_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
regulator_driver_api_area : ALIGN_WITH_INPUT { _regulator_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._regulator_driver_api.static.*))); _regulator_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
reset_driver_api_area : ALIGN_WITH_INPUT { _reset_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._reset_driver_api.static.*))); _reset_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
retained_mem_driver_api_area : ALIGN_WITH_INPUT { _retained_mem_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._retained_mem_driver_api.static.*))); _retained_mem_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
rtc_driver_api_area : ALIGN_WITH_INPUT { _rtc_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._rtc_driver_api.static.*))); _rtc_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
sdhc_driver_api_area : ALIGN_WITH_INPUT { _sdhc_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._sdhc_driver_api.static.*))); _sdhc_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
sensor_driver_api_area : ALIGN_WITH_INPUT { _sensor_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._sensor_driver_api.static.*))); _sensor_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
smbus_driver_api_area : ALIGN_WITH_INPUT { _smbus_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._smbus_driver_api.static.*))); _smbus_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
spi_driver_api_area : ALIGN_WITH_INPUT { _spi_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._spi_driver_api.static.*))); _spi_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
stepper_driver_api_area : ALIGN_WITH_INPUT { _stepper_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._stepper_driver_api.static.*))); _stepper_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
syscon_driver_api_area : ALIGN_WITH_INPUT { _syscon_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._syscon_driver_api.static.*))); _syscon_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
tee_driver_api_area : ALIGN_WITH_INPUT { _tee_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._tee_driver_api.static.*))); _tee_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
video_driver_api_area : ALIGN_WITH_INPUT { _video_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._video_driver_api.static.*))); _video_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
w1_driver_api_area : ALIGN_WITH_INPUT { _w1_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._w1_driver_api.static.*))); _w1_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
wdt_driver_api_area : ALIGN_WITH_INPUT { _wdt_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._wdt_driver_api.static.*))); _wdt_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
can_transceiver_driver_api_area : ALIGN_WITH_INPUT { _can_transceiver_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._can_transceiver_driver_api.static.*))); _can_transceiver_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
nrf_clock_control_driver_api_area : ALIGN_WITH_INPUT { _nrf_clock_control_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._nrf_clock_control_driver_api.static.*))); _nrf_clock_control_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
i3c_target_driver_api_area : ALIGN_WITH_INPUT { _i3c_target_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._i3c_target_driver_api.static.*))); _i3c_target_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
its_driver_api_area : ALIGN_WITH_INPUT { _its_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._its_driver_api.static.*))); _its_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
vtd_driver_api_area : ALIGN_WITH_INPUT { _vtd_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._vtd_driver_api.static.*))); _vtd_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
tgpio_driver_api_area : ALIGN_WITH_INPUT { _tgpio_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._tgpio_driver_api.static.*))); _tgpio_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
pcie_ctrl_driver_api_area : ALIGN_WITH_INPUT { _pcie_ctrl_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._pcie_ctrl_driver_api.static.*))); _pcie_ctrl_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
pcie_ep_driver_api_area : ALIGN_WITH_INPUT { _pcie_ep_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._pcie_ep_driver_api.static.*))); _pcie_ep_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
svc_driver_api_area : ALIGN_WITH_INPUT { _svc_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._svc_driver_api.static.*))); _svc_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
uart_driver_api_area : ALIGN_WITH_INPUT { _uart_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._uart_driver_api.static.*))); _uart_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
bc12_emul_driver_api_area : ALIGN_WITH_INPUT { _bc12_emul_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._bc12_emul_driver_api.static.*))); _bc12_emul_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
bc12_driver_api_area : ALIGN_WITH_INPUT { _bc12_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._bc12_driver_api.static.*))); _bc12_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
usbc_ppc_driver_api_area : ALIGN_WITH_INPUT { _usbc_ppc_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._usbc_ppc_driver_api.static.*))); _usbc_ppc_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
tcpc_driver_api_area : ALIGN_WITH_INPUT { _tcpc_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._tcpc_driver_api.static.*))); _tcpc_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
usbc_vbus_driver_api_area : ALIGN_WITH_INPUT { _usbc_vbus_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._usbc_vbus_driver_api.static.*))); _usbc_vbus_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
ivshmem_driver_api_area : ALIGN_WITH_INPUT { _ivshmem_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._ivshmem_driver_api.static.*))); _ivshmem_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
ethphy_driver_api_area : ALIGN_WITH_INPUT { _ethphy_driver_api_list_start = .; KEEP(*(SORT_BY_NAME(._ethphy_driver_api.static.*))); _ethphy_driver_api_list_end = .; } > drom0_0_seg AT > FLASH
ztest : ALIGN_WITH_INPUT
{
 _ztest_expected_result_entry_list_start = .; KEEP(*(SORT_BY_NAME(._ztest_expected_result_entry.static.*))); _ztest_expected_result_entry_list_end = .;
 _ztest_suite_node_list_start = .; KEEP(*(SORT_BY_NAME(._ztest_suite_node.static.*))); _ztest_suite_node_list_end = .;
 _ztest_unit_test_list_start = .; KEEP(*(SORT_BY_NAME(._ztest_unit_test.static.*))); _ztest_unit_test_list_end = .;
 _ztest_test_rule_list_start = .; KEEP(*(SORT_BY_NAME(._ztest_test_rule.static.*))); _ztest_test_rule_list_end = .;
} > drom0_0_seg AT > FLASH
 net_mgmt_event_static_handler_area : ALIGN_WITH_INPUT { _net_mgmt_event_static_handler_list_start = .; KEEP(*(SORT_BY_NAME(._net_mgmt_event_static_handler.static.*))); _net_mgmt_event_static_handler_list_end = .; } > drom0_0_seg AT > FLASH
 bt_l2cap_fixed_chan_area : ALIGN_WITH_INPUT { _bt_l2cap_fixed_chan_list_start = .; KEEP(*(SORT_BY_NAME(._bt_l2cap_fixed_chan.static.*))); _bt_l2cap_fixed_chan_list_end = .; } > drom0_0_seg AT > FLASH
 bt_gatt_service_static_area : ALIGN_WITH_INPUT { _bt_gatt_service_static_list_start = .; KEEP(*(SORT_BY_NAME(._bt_gatt_service_static.static.*))); _bt_gatt_service_static_list_end = .; } > drom0_0_seg AT > FLASH
 tracing_backend_area : ALIGN_WITH_INPUT { _tracing_backend_list_start = .; KEEP(*(SORT_BY_NAME(._tracing_backend.static.*))); _tracing_backend_list_end = .; } > drom0_0_seg AT > FLASH
 zephyr_dbg_info : ALIGN_WITH_INPUT
 {
  KEEP(*(".dbg_thread_info"));
 } > drom0_0_seg AT > FLASH
 symbol_to_keep : ALIGN_WITH_INPUT
 {
  __symbol_to_keep_start = .;
  KEEP(*(SORT(.symbol_to_keep*)));
  __symbol_to_keep_end = .;
 } > drom0_0_seg AT > FLASH
 shell_area : ALIGN_WITH_INPUT { _shell_list_start = .; KEEP(*(SORT_BY_NAME(._shell.static.*))); _shell_list_end = .; } > drom0_0_seg AT > FLASH
 shell_root_cmds_area : ALIGN_WITH_INPUT { _shell_root_cmds_list_start = .; KEEP(*(SORT_BY_NAME(._shell_root_cmds.static.*))); _shell_root_cmds_list_end = .; } > drom0_0_seg AT > FLASH
 shell_subcmds_area : ALIGN_WITH_INPUT { _shell_subcmds_list_start = .; KEEP(*(SORT_BY_NAME(._shell_subcmds.static.*))); _shell_subcmds_list_end = .; } > drom0_0_seg AT > FLASH
 shell_dynamic_subcmds_area : ALIGN_WITH_INPUT { _shell_dynamic_subcmds_list_start = .; KEEP(*(SORT_BY_NAME(._shell_dynamic_subcmds.static.*))); _shell_dynamic_subcmds_list_end = .; } > drom0_0_seg AT > FLASH
 cfb_font_area : ALIGN_WITH_INPUT { _cfb_font_list_start = .; KEEP(*(SORT_BY_NAME(._cfb_font.static.*))); _cfb_font_list_end = .; } > drom0_0_seg AT > FLASH
 tdata : ALIGN_WITH_INPUT
 {
  *(.tdata .tdata.* .gnu.linkonce.td.*);
 } > drom0_0_seg AT > FLASH
 tbss : ALIGN_WITH_INPUT
 {
  *(.tbss .tbss.* .gnu.linkonce.tb.* .tcommon);
 } > drom0_0_seg AT > FLASH
 PROVIDE(__tdata_start = ADDR(tdata));
 PROVIDE(__tdata_align = ALIGNOF(tdata));
 PROVIDE(__tdata_size = (SIZEOF(tdata) + __tdata_align - 1) & ~(__tdata_align - 1));
 PROVIDE(__tdata_end = __tdata_start + __tdata_size);
 PROVIDE(__tbss_align = ALIGNOF(tbss));
 PROVIDE(__tbss_start = ADDR(tbss));
 PROVIDE(__tbss_size = (SIZEOF(tbss) + __tbss_align - 1) & ~(__tbss_align - 1));
 PROVIDE(__tbss_end = __tbss_start + __tbss_size);
 PROVIDE(__tls_start = __tdata_start);
 PROVIDE(__tls_end = __tbss_end);
 PROVIDE(__tls_size = __tbss_end - __tdata_start);
.intList : ALIGN_WITH_INPUT
{
 KEEP(*(.irq_info*))
 KEEP(*(.intList*))
} > drom0_0_seg AT > IDT_LIST
  .flash.rodata_end : ALIGN(0x10)
  {
    . = ALIGN(4);
    _rodata_reserved_end = ABSOLUTE(.);
    _image_rodata_end = ABSOLUTE(.);
  } > drom0_0_seg AT > FLASH
.intList : ALIGN_WITH_INPUT
{
 KEEP(*(.irq_info*))
 KEEP(*(.intList*))
} > drom0_0_seg AT > IDT_LIST
 .stab 0 : ALIGN_WITH_INPUT { *(.stab) }
 .stabstr 0 : ALIGN_WITH_INPUT { *(.stabstr) }
 .stab.excl 0 : ALIGN_WITH_INPUT { *(.stab.excl) }
 .stab.exclstr 0 : ALIGN_WITH_INPUT { *(.stab.exclstr) }
 .stab.index 0 : ALIGN_WITH_INPUT { *(.stab.index) }
 .stab.indexstr 0 : ALIGN_WITH_INPUT { *(.stab.indexstr) }
 .gnu.build.attributes 0 : ALIGN_WITH_INPUT { *(.gnu.build.attributes .gnu.build.attributes.*) }
 .comment 0 : ALIGN_WITH_INPUT { *(.comment) }
 .debug 0 : ALIGN_WITH_INPUT { *(.debug) }
 .line 0 : ALIGN_WITH_INPUT { *(.line) }
 .debug_srcinfo 0 : ALIGN_WITH_INPUT { *(.debug_srcinfo) }
 .debug_sfnames 0 : ALIGN_WITH_INPUT { *(.debug_sfnames) }
 .debug_aranges 0 : ALIGN_WITH_INPUT { *(.debug_aranges) }
 .debug_pubnames 0 : ALIGN_WITH_INPUT { *(.debug_pubnames) }
 .debug_info 0 : ALIGN_WITH_INPUT { *(.debug_info .gnu.linkonce.wi.*) }
 .debug_abbrev 0 : ALIGN_WITH_INPUT { *(.debug_abbrev) }
 .debug_line 0 : ALIGN_WITH_INPUT { *(.debug_line .debug_line.* .debug_line_end ) }
 .debug_frame 0 : ALIGN_WITH_INPUT { *(.debug_frame) }
 .debug_str 0 : ALIGN_WITH_INPUT { *(.debug_str) }
 .debug_loc 0 : ALIGN_WITH_INPUT { *(.debug_loc) }
 .debug_macinfo 0 : ALIGN_WITH_INPUT { *(.debug_macinfo) }
 .debug_weaknames 0 : ALIGN_WITH_INPUT { *(.debug_weaknames) }
 .debug_funcnames 0 : ALIGN_WITH_INPUT { *(.debug_funcnames) }
 .debug_typenames 0 : ALIGN_WITH_INPUT { *(.debug_typenames) }
 .debug_varnames 0 : ALIGN_WITH_INPUT { *(.debug_varnames) }
 .debug_pubtypes 0 : ALIGN_WITH_INPUT { *(.debug_pubtypes) }
 .debug_ranges 0 : ALIGN_WITH_INPUT { *(.debug_ranges) }
 .debug_addr 0 : ALIGN_WITH_INPUT { *(.debug_addr) }
 .debug_line_str 0 : ALIGN_WITH_INPUT { *(.debug_line_str) }
 .debug_loclists 0 : ALIGN_WITH_INPUT { *(.debug_loclists) }
 .debug_macro 0 : ALIGN_WITH_INPUT { *(.debug_macro) }
 .debug_names 0 : ALIGN_WITH_INPUT { *(.debug_names) }
 .debug_rnglists 0 : ALIGN_WITH_INPUT { *(.debug_rnglists) }
 .debug_str_offsets 0 : ALIGN_WITH_INPUT { *(.debug_str_offsets) }
 .debug_sup 0 : ALIGN_WITH_INPUT { *(.debug_sup) }
  /DISCARD/ : { *(.note.GNU-stack) }
  .riscv.attributes 0 : ALIGN_WITH_INPUT
    {
    KEEP(*(.riscv.attributes))
    KEEP(*(.gnu.attributes))
    }
}
