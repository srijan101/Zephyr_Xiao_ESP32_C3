/*
 * Copyright (c) 2025 Srijan Ghimire, Jan 21 2025
 *
 * This is a SPDX license identifier indicating that the code is licensed under Apache-2.0
 */

#include <zephyr/kernel.h>
#include <zephyr/logging/log.h>
#include <zephyr/net/wifi.h>
#include <zephyr/net/wifi_mgmt.h>
#include <zephyr/device.h>
#include <zephyr/net/net_if.h>

LOG_MODULE_REGISTER(main, LOG_LEVEL_INF);

static void wifi_scan_result_cb(struct net_mgmt_event_callback *cb,
                               uint32_t mgmt_event,
                               struct net_if *iface)
{
	const struct wifi_scan_result *entry = (const struct wifi_scan_result *)cb->info;
	
	if (mgmt_event != NET_EVENT_WIFI_SCAN_RESULT) {
		return;
	}

	LOG_INF("SSID: %-32s | Channel: %d | RSSI: %d | Security: %d",
			entry->ssid, entry->channel, entry->rssi, entry->security);
}

static struct net_mgmt_event_callback wifi_cb;

int main(void)
{
	struct net_if *iface;
	struct wifi_scan_params scan_params = { 0 };

	// Wait for the network interface to be ready
	iface = net_if_get_default();
	if (!iface) {
		LOG_ERR("No network interface available");
		return -1;
	}

	// Register callback for scan results
	net_mgmt_init_event_callback(&wifi_cb, wifi_scan_result_cb,
								NET_EVENT_WIFI_SCAN_RESULT);
	net_mgmt_add_event_callback(&wifi_cb);

	LOG_INF("Starting WiFi scan...");

	if (net_mgmt(NET_REQUEST_WIFI_SCAN, iface, &scan_params,
				 sizeof(struct wifi_scan_params))) {
		LOG_ERR("WiFi scan request failed");
		return -1;
	}

	// Main loop
	while (1) {
		k_sleep(K_SECONDS(1));
	}

	return 0;
}
