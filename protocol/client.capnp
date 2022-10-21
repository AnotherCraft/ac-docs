@0xf9a34189a3288933;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

struct CachedShader {
	binaryFormat @0 :Int32;
	data @1 :Data;

	struct HiveDependency {
		key @0 :Text;
		value @1 :Text;
	}
	hiveDependencies @2 :List(HiveDependency);

	struct BootstrapTexture {
		var @0 :Text;
		file @1 :Text;
	}
	bootstrapTextures @3 :List(BootstrapTexture);

	struct Include {
		file @0 :Text;
		lastModified @1 :UInt64;
	}
	includes @4 :List(Include);

	hiveVarFs @5 :List(Text);
}