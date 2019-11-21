# nov/19/2019 18:12:31 by RouterOS 6.45.7
# software id = xxx
#
# model = RB941-2nD
# serial number = xxx
/interface bridge
add admin-mac=8d:cf:7b:f6:5a:a3 auto-mac=no comment=defconf name=bridge
/interface ethernet
set [ find default-name=ether1 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full mac-address=\
    43:97:1f:52:8a:b6
set [ find default-name=ether2 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full
set [ find default-name=ether3 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full
set [ find default-name=ether4 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-Ce \
    country=russia disabled=no distance=indoors frequency=auto mode=ap-bridge \
    ssid=RB941WiFi wireless-protocol=802.11
/interface pppoe-client
add add-default-route=yes disabled=no interface=ether1 name=pppoe-out1 \
    password=MyStrongPPPoEPassword use-peer-dns=yes user=MyPPPoEName
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa-psk,wpa2-psk mode=\
    dynamic-keys supplicant-identity=MikroTik wpa-pre-shared-key=MyStrongPassword \
    wpa2-pre-shared-key=MyStrongPassword
/ip dhcp-client option
add code=55 name=parameter_request_list value=0x0103062179F9
/ip pool
add name=dhcp ranges=172.16.0.10-172.16.0.254
/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge name=defconf
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge comment=defconf interface=wlan1
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
add interface=pppoe-out1 list=WAN
/ip address
add address=172.16.0.1/24 comment=defconf interface=ether2 network=172.16.0.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid,parameter_request_list \
    disabled=no interface=ether1
/ip dhcp-server network
add address=172.16.0.0/24 comment=defconf gateway=172.16.0.1 netmask=24
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=172.16.0.1 name=router.lan
/ip firewall filter
add action=accept chain=forward protocol=udp
add action=accept chain=input protocol=igmp
add action=accept chain=output protocol=igmp
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
/ip upnp
set enabled=yes
/ip upnp interfaces
add interface=bridge type=internal
add interface=pppoe-out1 type=external
/routing igmp-proxy interface
add alternative-subnets=0.0.0.0/0 interface=ether1 upstream=yes
add
/system clock
set time-zone-name=Asia/Novokuznetsk
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
