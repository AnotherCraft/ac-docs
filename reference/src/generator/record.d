import std.format;
import std.range;
import std.algorithm;
import std.path;
import std.regex;

import yaml;

static Record[string] records;

Record recordVal(dyaml.Node n, string key)
{
	if (!n.containsKey(key))
		return null;

	string val = n[key].as!string;
	return records.get(val, null);
}

class Record
{

public:
	string name;
	string filePath;
	dyaml.Node yaml;

	Record[] children, usedIn;

public:
	void process()
	{
		if (auto v = yaml.recordVal("parent"))
			v.children ~= this;

		if (yaml.containsKey("properties"))
		{
			foreach (pyaml; yaml["properties"].sequence)
			{
				if (auto v = pyaml.recordVal("type"))
					v.usedIn ~= this;
			}
		}
	}

	string generateContent()
	{
		string result;

		// Title
		result ~= "# `%s`\n".format(name);

		if (auto v = yaml.stringVal("parent"))
			result ~= "> **Parent:** %s<br>\n".format(recordLink(v));

		if (!children.empty)
			result ~= "\n> **Children:**<br>\n> %s\n".format(children.map!(x => recordLink(x))
					.join(", "));

		if (!usedIn.empty)
			result ~= "\n> **Used in:**<br>\n> %s\n".format(
				usedIn.uniq.map!(x => recordLink(x))
					.array.sort.join(", "));

		if (yaml.containsKey("seeAlso"))
			result ~= "\n> **See also:**<br>\n> %s\n".format(yaml["seeAlso"].sequence!string
					.map!(x => recordLink(x))
					.array.sort
					.join(", "));

		result ~= "\n";

		if (auto v = yaml.stringVal("description"))
			result ~= "%s\n".format(processMarkdown(v));

		if (yaml.containsKey("properties"))
		{
			result ~= "## Properties\n";

			foreach (pyaml; yaml["properties"].sequence.array.sort!((a, b) => a["name"].as!string < b["name"]
					.as!string))
			{
				string titleNote;
				if (auto v = pyaml.stringVal("titleNote"))
					titleNote = " (%s)".format(v);

				result ~= "### `%s`%s\n".format(
					pyaml.stringVal("name"),
					titleNote
				);

				if (auto v = pyaml.stringVal("type"))
					result ~= "> **Type:** %s<br>\n".format(recordLink(v));

				if (auto v = pyaml.stringVal("default"))
					result ~= "> **Default value:** `%s`<br>\n".format(v);

				result ~= "\n";

				if (auto v = pyaml.stringVal("description"))
					result ~= "%s\n".format(processMarkdown(v));
			}
		}

		return result;
	}

private:
	string recordLink(string recordName)
	{
		immutable bool[string] predefinedRecords = [
			"bool": true,
			"int": true,
			"float": true,
			"string": true,
		];

		if (recordName in predefinedRecords)
			return recordName;

		string path = pathToRecord(recordName);
		if (!path)
			return "<strike>%s</strike>".format(recordName);

		return "[%s](%s)".format(recordName, path);
	}

	string recordLink(Record r)
	{
		return "[%s](%s)".format(r.name, pathToRecord(r));
	}

	string pathToRecord(string recordName)
	{
		return pathToRecord(records.get(recordName, null));
	}

	string pathToRecord(Record r)
	{
		return r ? r.filePath.relativePath(filePath.dirName).replace('\\', '/') : null;
	}

	string processMarkdown(string str)
	{
		auto r = ctRegex!r"\$\[([a-zA-Z0-9_]+)\]";
		return str.replaceAll!(c => recordLink(c[1]))(r);
	}

}
