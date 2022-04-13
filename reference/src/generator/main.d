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
			outDirectory = buildPath(outRootDir, v);

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
}
