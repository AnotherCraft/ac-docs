import std.stdio;
import std.file;
import std.format;
import std.path;
import std.array;

import record;
import yaml;

static immutable string outRootDir = "reference";

void main() {
	if(outRootDir.exists)
		outRootDir.rmdirRecurse();

	outRootDir.mkdir();
	
	// Scan and create records
	foreach(filePath; "src".dirEntries("*.yaml", SpanMode.breadth)) {
		writeln("Parsing ", filePath, "...");

		auto yaml = dyaml.Loader.fromFile(filePath).load();

		string outDirectory = outRootDir;
		if(auto v = yaml.stringVal("outDirectory"))
			outDirectory ~= "/" ~ v;

		outDirectory.mkdirRecurse();

		foreach(dyaml.Node recYaml; yaml["records"]) {
			Record r = new Record();
			r.yaml = recYaml;
			r.name = recYaml["name"].as!string;
			r.filePath = "%s/%s.md".format(outDirectory, r.name);
			r.pathToRoot = outRootDir.asRelativePath(outDirectory).array;

			records[r.name] = r;
		}
	}

	// Generate files from records
	foreach(Record r; records)
		std.file.write(r.filePath, r.generateContent());
}