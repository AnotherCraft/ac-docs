import std.stdio;
import std.file;
import std.format;
static import dyaml;

import record;

static immutable string outRootDir = "reference";

static Record[string] records;

void main() {
	if(outRootDir.exists)
		outRootDir.rmdirRecurse();

	outRootDir.mkdir();
	
	// Scan and create records
	foreach(filePath; "src".dirEntries("*.yaml", SpanMode.breadth)) {
		writeln("Parsing ", filePath, "...");

		auto yaml = dyaml.Loader.fromFile(filePath);

		string outDirectory = outRootDir;
		if(yaml.containsKey("outDirectory"))
			outDirectory ~= "/" ~ yaml["outDirectory"].as!string;

		outDirectory.mkdirRecursive();

		foreach(recYaml; yaml["records"]) {
			Record r = new Record();
			r.yaml = recYaml;
			r.name = recYaml["name"].as!string;
			r.filePath = "%s/%s.md".format(outDirectory, r.name);

			records[r.name] = r;
		}
	}

	// Generate files from records
	foreach(Record r; records)
		std.file.write(r.filePath, r.generateContent());
}