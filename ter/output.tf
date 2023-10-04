output "vms_external_ip" {
value = tomap({
    clickhouse  = "${yandex_compute_instance.clickhouse.*.network_interface.0.nat_ip_address}"
    vector      = "${yandex_compute_instance.vector.*.network_interface.0.nat_ip_address}"
    lighthouse  = "${yandex_compute_instance.lighthouse.*.network_interface.0.nat_ip_address}"
})
}