import std.stdio;
import std.file;
import std.format;
import std.path;
import std.array;
import std.algorithm;

import record;
import yaml;

void main()
{
	immutable string outRootDir = "reference".absolutePath;
	immutable string srcRootDir = "src".absolutePath;

	if (outRootDir.exists)
		outRootDir.rmdirRecurse();

	outRootDir.mkdir();

	// Scan and create records
	foreach (filePath; srcRootDir.dirEntries("*.yaml", SpanMode.breadth))
	{
		writeln("Parsing ", filePath, "...");

		auto yaml = dyaml.Loader.fromFile(filePath).load();

		string outDirectory = buildPath(outRootDir, filePath.dirName.relativePath(srcRootDir));
		if (auto v = yaml.stringVal("outDirectory"))
			outDirectory = buildPath(outDirectory, v);

		outDirectory.mkdirRecurse();

		foreach (dyaml.Node recYaml; yaml["records"])
		{
			Record r = new Record();
			r.yaml = recYaml;
			r.name = recYaml["name"].as!string;
			r.filePath = "%s/%s.md".format(outDirectory, r.name);

			records[r.name] = r;
		}
	}

	// Process records
	foreach (Record r; records)
		r.process();

	// Generate files from records
	foreach (Record r; records)
		std.file.write(r.filePath, r.generateContent());

	// Generate index file
	{
		string str;
		str ~= "# List of all classes\n";

		Record[][string] recs;
		foreach(Record r; records)
			recs.require(r.filePath.dirName, null) ~= r;

		foreach(string dir; recs.keys.array.sort) {
			str ~= "### `%s`\n".format(dir.relativePath(outRootDir));
			str ~= recs[dir].sort!((a, b) => a.name < b.name).map!(r => "[%s](%s)".format(r.name, r.filePath.relativePath(outRootDir))).join(", ");
			str ~= "\n";
		}
		std.file.write(outRootDir.buildPath("README.md"), str);
	}
}
