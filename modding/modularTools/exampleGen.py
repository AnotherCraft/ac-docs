from PIL import Image
import os
import re
import yaml
import math
import itertools

materials = {}
parts = {}
tools = {}

def main():
	os.mkdir("out")
	
	sourcePalette = Image.open("parts/sourcePalette.png")
	regex = r"^(?:.*[/\\])?([^/]+)_[^/_]+$"

	# List materials
	for file in os.listdir("materials"):
		k = re.search(regex, file)
		if k:
			materials[k.group(1)] = {}

	# Load materials
	for k, v in materials.items():
		print("Loading material:", k)
		v["tex1"] = Image.open("materials/" + k + "_tex1.png").convert("RGBA")
		
		paletteImg = Image.open("materials/" + k + "_palette.png")
		palette = {}
		for y in range(min(sourcePalette.height, paletteImg.height)):
			for x in range(min(sourcePalette.width, paletteImg.width)):
				srcPx = sourcePalette.getpixel((x, y))
				tgtPx = paletteImg.getpixel((x, y))
				if srcPx != (0, 0, 0) and tgtPx != (0, 0, 0):
					palette[srcPx] = tgtPx

		v["palette"] = palette

	# List parts
	for file in os.listdir("parts"):
		k = re.search(regex, file)
		if k:
			parts[k.group(1)] = {}

	# Load parts
	for k, v in parts.items():
		print("Loading part:", k)
		v["mask"] = Image.open("parts/" + k + "_mask.png").convert("RGBA")
		v["overlay"] = Image.open("parts/" + k + "_overlay.png")

	# Load tools
	for file in os.listdir("tools"):
		k = os.path.splitext(file)[0]
		print("Loading tool:", k)
		tools[k] = yaml.safe_load(open("tools/" + file))

	# Generate
	for tk, tool in tools.items():
		toolParts = tool["parts"]

		for comb in itertools.combinations_with_replacement(materials.keys(), len(toolParts)):
			img = Image.new("RGBA", (32, 32))

			name = tk

			for pix, mk in enumerate(comb):
				name += "__" + toolParts[pix] + "_" + mk

			print("Generating: ", name)

			for pix, mk in enumerate(comb):
				part = parts[toolParts[pix]]
				material = materials[mk]

				mask = part["mask"]
				tex = material["tex1"].copy()
				texp = tex.load()
			
				for y in range(tex.height):
					for x in range(tex.width):
						r, g, b, a = texp[x, y]
						mp = mask.getpixel((x, y))
						a = math.floor(a * mp[3] / 255)
						texp[x, y] = (r, g, b, a)

				img = Image.alpha_composite(img, tex)

				tex = part["overlay"].copy()
				texp = tex.load()
				palette = material["palette"]

				for y in range(tex.height):
					for x in range(tex.width):
						r, g, b, a = texp[x, y]
						(r, g, b) = palette.get((r, g, b), (r, g, b))
						texp[x, y] = (r, g, b, a)

				img = Image.alpha_composite(img, tex)

			img.save("out/" + name + ".png")

				

main()