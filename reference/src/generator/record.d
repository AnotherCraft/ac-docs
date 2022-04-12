import std.format;
import std.range;
import std.algorithm;

import yaml;

static Record[string] records;

class Record {

public:
	string name;
	string filePath, pathToRoot;
	dyaml.Node yaml;

public:
	string generateContent() {
		string result;

		// Title
		result ~= "# %s\n".format(name);

		if(auto v = yaml.stringVal("parent"))
			result ~= "> **Parent:** %s<br>\n".format(recordLink(v));

		if(yaml.containsKey("components"))
			result ~= "> **Components:** %s<br>\n".format(yaml["components"].sequence!string.map!(x => recordLink(x)).join(", "));

		if(yaml.containsKey("seeAlso"))
			result ~= "> **See also:** %s<br>\n".format(yaml["seeAlso"].sequence!string.map!(x => recordLink(x)).join(", "));

		result ~= "\n";

		if(auto v = yaml.stringVal("description"))
			result ~= "%s\n".format(v);

		//if(yaml.containsKey("properties"))

		return result;
	} 

private:
	string recordLink(string recordName) {
		string path = pathToRecord(recordName);
		if(!path)
			return "<span style='color: red;'>%s</span>".format(recordName);
		
		return "[%s](%s)".format(recordName, path);
	}

	string pathToRecord(string recordName) {
		if(recordName !in records)
			return null;
		
		return pathToRoot ~ "/" ~ records[recordName].filePath;
	}

}