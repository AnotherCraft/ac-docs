@0xde6a18a50d05c804;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";

# Contains various data for the player not useful to the server, but for client customization
# For example hotbar mappings, UI layouts, ...
struct PlayerClientData {

	# Slot mapping for hotbars & possibly other stuff
	struct SlotMapping {
		key @0 :Text;
		linkStr @1 :Text;
	}
	slotMapping @0 :List(SlotMapping);

}