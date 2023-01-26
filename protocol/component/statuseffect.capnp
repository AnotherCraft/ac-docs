@0xa3c5e679c3d4eaab;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "../util.capnp";

struct SETCDKeepAliveApplication {
	timeoutTime @0 :Util.GameTime;
}

struct SETCDTimeoutApplication {
	timeoutTime @0 :Util.GameTime;
}

struct SETCDIncrementalStatistic {
	value @0 :Float32;
}