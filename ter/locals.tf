locals {
metadata = {
    serial-port-enable = "1"
    user-data = "${file("./cc.yml")}"
    }
}