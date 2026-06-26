extends Node

const IP_ADDRESS: String = '127.0.0.1'
const PORT: int = 11221

var peer: ENetMultiplayerPeer

signal server_started

func start_server() -> void:
	#setup_upnp()
	#peer = ENetMultiplayerPeer.new()
	#peer.create_server(PORT)
	#multiplayer.multiplayer_peer = peer
	server_started.emit()
	
func start_client(ip_address: String) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer

func setup_upnp() -> void:
	var upnp: UPNP = UPNP.new()
	
	# Look for UPnP-compatible routers on the local network
	var discover_result: int = upnp.discover()
	
	if discover_result != UPNP.UPNP_RESULT_SUCCESS:
		push_warning("UPnP Discovery Failed (Code %d). External players may not be able to connect." % discover_result)
		return

	# Verify a valid gateway/router was actually found
	var gateway = upnp.get_gateway()
	if not gateway or not gateway.is_valid_gateway():
		push_warning("UPnP: Invalid gateway. Port mapping skipped.")
		return

	# Request the router to open the port for both UDP and TCP 
	# (ENet primarily uses UDP, but mapping both covers all bases)
	var map_udp: int = upnp.add_port_mapping(PORT, PORT, "Godot_Game_UDP", "UDP")
	var map_tcp: int = upnp.add_port_mapping(PORT, PORT, "Godot_Game_TCP", "TCP")

	if map_udp == UPNP.UPNP_RESULT_SUCCESS and map_tcp == UPNP.UPNP_RESULT_SUCCESS:
		# Success! Fetch the public IP to display to the host
		var public_ip: String = upnp.query_external_address()
		print("UPnP Success! Your public IP is: ", public_ip)
		print("Provide this IP and Port (%d) to your external friends." % PORT)
	else:
		push_warning("UPnP Port Mapping Failed. You may need to manually forward port %d on your router." % PORT)
