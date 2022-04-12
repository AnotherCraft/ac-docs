import std.format;
static import dyaml;

class Record {

public:
	string name;
	string filePath;
	dyaml.Node yaml;

public:
	string generateContent() {
		string result;

		// Title
		result ~= "# %s\n".format(name);

		return result;
	} 

}