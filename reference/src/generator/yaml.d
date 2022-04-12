public static import dyaml;

string stringVal(dyaml.Node n, string key) {
	if(!n.containsKey(key))
		return null;
	
	return n[key].as!string();
}