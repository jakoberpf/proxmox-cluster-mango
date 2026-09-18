# Compute capacity and expansion plan

This document records the capacity measurements made on 2026-09-09 and a
German used-market snapshot from the same date. Listings and prices are only
planning inputs; confirm the exact configuration, condition, warranty, and
shipping cost before purchase.

## Decision

Mango is CPU constrained. It still has useful memory headroom, so adding RAM
would not address the observed bottleneck. The preferred expansion is two
matching, complete 2U enterprise servers with at least 128 GB ECC RAM each,
followed by a third server only when measured demand justifies its idle power.
Two additional hosts produce a conventional three-node Proxmox quorum with
mango and add substantially more compute than an in-place CPU replacement.
The two new Intel nodes would be the matching live-migration pair; Proxmox does
not guarantee online migration between AMD mango and Intel hosts.

The best-value listing in the snapshot is the Dell R740xd at EUR 880 per
server. Two units cost EUR 1,760 before storage and network adapters. They are
better suited to the available rack space and sustained loads than a 1U
server, while the EUR 720 R640 is attractive when rack density matters more
than fan noise and expansion room.

An in-place Threadripper 2990WX remains a useful low-cost bridge. It doubles
the physical core count without buying another platform, but it leaves all
workloads and storage on one aging host and increases cooling demand. Do not
install it until mango has thermal margin under sustained load.

## Observed bottleneck

Mango was sampled while it was carrying its normal running guests and Ceph was
deep-scrubbing three placement groups.

| Resource | Observation | Capacity implication |
| --- | --- | --- |
| CPU | Threadripper 2950X, 16 cores / 32 threads, 180 W TDP | Primary constraint |
| CPU load | Load average approximately 38-41; sampled CPU approximately 71% guest, 10% system, 15% idle | Runnable work regularly exceeds the 32 logical CPUs |
| CPU pressure | `cpu.pressure` approximately 16-17% | Work is spending material time waiting for CPU |
| Temperature | Tdie reached 68 C, [AMD's published maximum operating temperature](https://www.amd.com/en/support/downloads/drivers.html/processors/ryzen-threadripper/ryzen-threadripper-2000-series/amd-ryzen-threadripper-2950x.html) for this CPU | No demonstrated thermal margin for a 250 W CPU |
| Memory | 256 GB installed, 251 GiB usable, approximately 78-80 GiB available, no swap | RAM is not the current constraint; all eight DIMM slots are occupied |
| Memory pressure | Near zero during sampling | More RAM alone will not improve current throughput |
| Storage | Six 16 TB HDD OSDs showed elevated latency during deep scrub | Storage maintenance can add latency, but historical host I/O wait remained low |
| Network | Active Intel I211 link is 1 GbE; onboard AQC107 10 GbE was down | Additional Ceph clients need a faster storage path |

The Proxmox RRD history supports the point-in-time sample:

| Window | Average CPU use | 95th percentile | Maximum |
| --- | ---: | ---: | ---: |
| 1 hour | 83.0% | 88.8% | 89.8% |
| 1 day | 63.7% | 87.4% | - |
| 1 week | 45.3% | 81.7% | 87.0% |
| 1 month | 16.5% | 59.8% | - |

The sharp increase across the shorter windows means the recent demand matters
more than the monthly average. VM 410 was the largest CPU consumer, averaging
about ten physical-core equivalents over the week and reaching about twenty at
the 95th percentile. Guest sizing and application changes remain the owning
stack repository's responsibility.

Mango's ASUS ROG Zenith Extreme Alpha has eight occupied 32 GB DDR4-2666 UDIMM
slots and is already at its 256 GB platform limit. A larger memory target
therefore requires a platform replacement or additional nodes.

## Upgrade paths

### 1. Populate with complete used enterprise servers

The complete systems in the market snapshot cost less than building equivalent
nodes in the spare chassis from individually purchased used parts.

| System | Advertised configuration | Price on 2026-09-09 | Fit |
| --- | --- | ---: | --- |
| [Dell PowerEdge R640, Essen](https://www.kleinanzeigen.de/s-anzeige/dell-poweredge-r640-server-8xsff-2-xeon-gold-6138-128-gb-ram/3489604466-228-2042) | 1U, 2x Xeon Gold 6138, 40 cores / 80 threads total, 128 GB ECC, H740P, 8 SFF, 2x10 GbE SFP+, iDRAC9, 2x750 W, no disks | EUR 720 negotiable | Lowest purchase price and already has 10 GbE; dense and likely loud |
| [Dell PowerEdge R740xd, Essen](https://www.kleinanzeigen.de/s-anzeige/2-x-dell-poweredge-r740xd-server-24-sff-2-gold-6138-128gb/3467958502-228-2042) | 2U, 2x Xeon Gold 6138, 40 cores / 80 threads total, 128 GB ECC, H740P, 24 SFF, 4x1 GbE, iDRAC9, 2x1100 W, rails, no disks | EUR 880 each; two advertised | Preferred initial purchase; more drive and PCIe room, but needs a fast storage-network adapter |
| [HPE ProLiant DL360 Gen10, Nuremberg](https://www.kleinanzeigen.de/s-anzeige/hpe-proliant-dl360-gen10-server-2x-xeon-gold-128gb-ram/3449132816-228-6816) | 1U, 2x Xeon Gold 6138, 128 GB, 10 GbE | EUR 950 negotiable | Local alternative to the R640 |
| [HPE ProLiant DL380 Gen10](https://www.ebay.de/itm/307034157409) | 2U, 2x Xeon Gold 6230, 40 cores / 80 threads total, 128 GB, 8 NVMe capable, 2x10/40 GbE QSFP | EUR 1,019; seller in Hungary | Strong specification and warranty claim, but not a German pickup |
| [Dell PowerEdge R6525](https://www.kleinanzeigen.de/s-anzeige/dell-poweredge-r6525-1u-server-2x-amd-epyc-7313-256gb-ram/3488049143-228-2932) | 1U, 2x EPYC 7313, 32 cores / 64 threads total, 256 GB, 4x480 GB SSD, dual 10 GbE | EUR 3,500 | Newer and more efficient platform, but much higher capital cost |

Intel specifies each [Xeon Gold 6138](https://www.intel.com/content/www/us/en/products/sku/120476/intel-xeon-gold-6138-processor-27-5m-cache-2-00-ghz/specifications.html)
as a 20-core, 125 W, six-memory-channel processor. A dual-socket node therefore
has a nominal 250 W CPU TDP before memory, drives, fans, and adapters. It also
has NUMA boundaries; benchmark representative VMs before assuming that 40 old
server cores equal 40 newer desktop or EPYC cores.

Before buying, request an iDRAC or iLO screenshot showing the service tag,
component inventory, hardware log, fan state, power-supply state, and lifetime
energy or recent power history. Confirm that both CPU sockets have identical
processors, the 128 GB memory layout uses both CPUs' channels, all drive
caddies needed for boot media are included, and the machines accept ordinary
PCIe network adapters without a missing riser.

### 2. Build EPYC nodes in the spare chassis

A used [Supermicro H11SSL-i and EPYC 7502 bundle](https://www.ebay.de/itm/186088810556)
was approximately EUR 719 before import costs. A German listing for 128 GB as
8x16 GB DDR4-2666 RDIMM was approximately
[EUR 520](https://www.ebay.de/itm/137629976229). Adding a cooler, suitable PSU,
mirrored SSDs, brackets, and networking puts a realistic node near EUR
1,600-1,900, or EUR 4,800-5,700 for three.

This route provides 32 cores / 64 threads in a single socket, eight memory
channels, server management, and a cleaner future memory expansion path. Its
advantages do not recover the roughly EUR 720-1,180 per-node premium over the
complete R740xd through electricity alone unless measurement shows a large,
sustained power difference.

### 3. Upgrade mango in place

A used Threadripper 2990WX was approximately EUR 442-450. It offers 32 cores /
64 threads in the existing socket at a 250 W TDP. It is the cheapest way to add
parallel throughput, and the
[ASUS CPU support list](https://rog.asus.com/motherboards/rog-zenith/rog-zenith-extreme-alpha-model/helpdesk_cpu/)
supports it on every board revision from BIOS 0207. Mango has BIOS 2001. This
option does not add node redundancy, memory capacity, storage distribution, or
a second maintenance domain. Its four-die NUMA layout also makes workload
placement and memory locality more important.

Use this only as a bridge or after deciding that a multi-node cluster is not
needed. Improve cooling first, then validate temperatures and clock behavior
under a long stress test before moving production workloads back onto it.

## Purchase sequence

1. Buy two matching R740xd systems if the listing passes the hardware and power
   checks. Use the two new machines with mango to establish three physical
   Proxmox voters.
2. Install mirrored enterprise SSD boot devices. Keep the hardware RAID mode,
   HBA mode, and replacement procedure consistent across both nodes.
3. Fit a supported InfiniBand HCA and cable in mango and each new node. Retain
   Ethernet for management and Corosync.
4. Burn in CPU, memory, disks, both PSUs, fans, and network links before joining
   production. Measure idle and representative-load wall power with the same
   workload and power policy on each host.
5. Migrate a representative compute workload and compare completed work per
   kilowatt-hour, p95 latency, CPU ready time, NUMA behavior, and fan noise.
6. Purchase or build the third additional node only after the first two nodes'
   RRD history establishes the remaining demand.

Cross-vendor live migration between AMD mango and Intel expansion nodes needs
a common virtual CPU model but remains unsupported as a guaranteed operation.
The [Proxmox cluster guidance](https://pve.proxmox.com/wiki/Migrate_to_Proxmox_VE?trk=public_post_comment-text)
states that online migration is supported only between nodes with CPUs from the
same vendor. Use generic x86-64-v2 or a tested common model where a guest might
cold-start on either vendor. Plan routine live migration between the two
matching Intel servers, and test cold starts on mango separately. Changing a
guest CPU model belongs in its owning stack repository.

If guaranteed live migration between every compute node is a firm requirement,
buy same-vendor AMD EPYC nodes instead, or retire mango from the compute and HA
placement set. That requirement can justify the EPYC build premium even when
electricity savings alone cannot.

## Power and operating cost

At the German household planning price used for this comparison, EUR 0.4055 per
kWh from [Destatis table 61243-0001 for the second half of
2025](https://genesis.destatis.de/datenbank/online/table/61243-0001/), continuous
power costs approximately:

| Continuous draw | Annual electricity |
| ---: | ---: |
| 50 W | EUR 178 |
| 70 W | EUR 249 |
| 100 W | EUR 355 |
| 150 W | EUR 533 |
| 200 W | EUR 710 |
| 250 W | EUR 888 |
| 300 W | EUR 1,066 |

For three additional servers, 80 W each at idle costs about EUR 853 per year;
150 W each costs EUR 1,598; 200 W each costs EUR 2,131; and 300 W each costs EUR
3,197. Powering a third node before it is useful can therefore erase its low
purchase price quickly.

A 100 W measured efficiency advantage saves about EUR 355 per year at this
tariff. The EUR 2,780 purchase-price gap between the EUR 720 R640 and EUR 3,500
R6525 would take about 7.8 years to recover at a full 100 W continuous saving,
before considering performance, warranty, or resale value. Compare joules per
completed job as well as idle watts; a faster node can return to idle sooner.

The TDP printed on a CPU is not server wall power. Purchase decisions should use
seller power history where available and then measurements from a smart PDU or
plug-in meter. Record at least powered-off standby, idle, normal workload, and
sustained full-load draw.

## Voltaire 4036 InfiniBand fabric

The existing Voltaire Grid Director 4036 can provide a fast Ceph and migration
fabric. It is a 36-port QDR InfiniBand switch with 40 Gb/s link signaling,
non-blocking switching, a 4,096-byte InfiniBand MTU, an embedded subnet manager,
and redundant power supplies. It is InfiniBand rather than 40 Gb Ethernet, so
Ceph must use IP over InfiniBand (IPoIB).

The [4036 data sheet](https://cw.infinibandta.org/files/showcase_product/110810.143805.288.Grid-Director-4036-WEB-043009.pdf)
states 106 W typical and 216 W maximum switch power, with optics adding power
per port. At the planning electricity price that is approximately EUR 377 per
year at typical draw or EUR 767 at the published maximum. Measure the actual
switch and cable configuration before comparing it with used 10/25 GbE.

### Intended traffic split

| Fabric | Traffic |
| --- | --- |
| Ethernet | Host management, PVE API/UI, SSH, and a dedicated physical 1 GbE link for the primary Corosync ring |
| IPoIB on a dedicated subnet, for example `10.40.0.0/24` without a gateway | Ceph client/public traffic, Ceph OSD replication once OSDs span nodes, live migration, and bulk host-to-host transfers |

Do not make the 4036 the only path for Corosync quorum. It is an old, single
physical switch and therefore a shared failure domain. A second Corosync link
is useful only when it uses an independent NIC, switch, and power path. The
[Proxmox cluster guidance](https://pve.proxmox.com/wiki/Migrate_to_Proxmox_VE?trk=public_post_comment-text)
states that Corosync needs stable, low-latency connectivity and recommends a
dedicated physical network plus an independent redundant network.

Start with one IPoIB subnet for Ceph. The
[Ceph network configuration reference](https://docs.ceph.com/en/latest/rados/configuration/network-config-ref/)
notes that a separate cluster network adds complexity and is often unnecessary
with a sufficiently fast public network. Creating two IP subnets on the same
4036 does not add physical fault isolation. Add a separate Ceph cluster network
only after measurement shows replication or recovery traffic harming clients
and an independent failure domain is available.

Use Ceph's normal TCP messenger over IPoIB. Do not base the design on Ceph's
limited `async+rdma` transport. Begin in IPoIB datagram mode with MTU 4092; the
[Linux IPoIB documentation](https://docs.kernel.org/infiniband/ipoib.html)
describes the datagram and connected modes. Benchmark connected mode later only
if every HCA, driver, and node supports it consistently.

Host-level Ceph clients, including Proxmox RBD or CephFS storage, can use IPoIB
directly. The existing Ceph CSI clients run inside guests. Their packets will
not automatically use the host's IPoIB interface, and IPoIB is not an ordinary
Ethernet bridge for attaching VM NICs. A future network design must give those
guest subnets explicit routed reachability to Ceph's advertised IPoIB monitor
and OSD addresses, with matching firewall and return routes. That change spans
the shared SDN contract and the owning stack repositories and needs its own
reviewed plan.

### Host adapters and cables

Each node needs a QDR-compatible InfiniBand HCA in a suitable PCIe x8 slot and
a QSFP cable. Mellanox ConnectX-3 VPI adapters such as MCX354A-QCBT support QDR;
the FDR MCX354A-FCBT can negotiate down to the switch's QDR rate. The
[ConnectX-3 product brief](https://cw.infinibandta.org/files/showcase_product/120329.120919.198.PB_ConnectX3_VPI_Card.pdf)
documents the VPI modes and PCIe interface. Used cards require checks for the
correct full-height or low-profile bracket, non-OEM-locked firmware, and an
InfiniBand port mode. Short in-rack links can use QDR-rated passive QSFP copper
cables.

The Proxmox kernel must expose `mlx4_core`, `mlx4_ib`, and the IPoIB interface on
ConnectX-3. The switch also needs one active subnet manager; its embedded manager
is sufficient for the initial test, but its configuration and restart behavior
must be documented.

### Validation before production

1. Cold-boot the switch and verify both power supplies, fans, firmware, port
   state, and embedded subnet-manager state.
2. Connect two non-production nodes and use `ibstat`, `ibv_devinfo`,
   `ibnetdiscover`, and `iblinkinfo` to verify a 4x QDR link end to end.
3. Assign temporary IPoIB addresses, set MTU 4092, and verify bidirectional
   pings at the intended packet size without fragmentation.
4. Run parallel `iperf3` streams and a multi-hour transfer. Record throughput,
   CPU cost, errors, link resets, temperatures, and switch wall power.
5. Test a cable removal, host reboot, switch reboot, and subnet-manager recovery.
6. Only then design the persistent Proxmox interfaces and a staged Ceph network
   migration. Review that operation separately because network activation and
   Ceph configuration changes are outside the default play.

All six current Ceph OSDs remain inside mango. The InfiniBand fabric can speed
access from new compute nodes, but it cannot provide storage-node high
availability until OSDs, monitors, and managers are deliberately distributed
across physical hosts. That storage redesign requires separate capacity,
failure-domain, recovery-bandwidth, and data-protection planning.
