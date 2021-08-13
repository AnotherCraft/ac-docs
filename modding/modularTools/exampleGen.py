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
	try:
		os.mkdir("out")
	except Exception:
		pass

	sourcePalette = Image.open("sourcePalette.png").convert("RGBA")
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
		
		paletteImg = Image.open("materials/" + k + "_palette.png").convert("RGBA")
		palette = {}
		for y in range(min(sourcePalette.height, paletteImg.height)):
			for x in range(min(sourcePalette.width, paletteImg.width)):
				sr, sg, sb, sa = sourcePalette.getpixel((x, y))
				tr, tg, tb, ta = paletteImg.getpixel((x, y))
				if ta != 0 and sa != 0:
					palette[(sr, sg, sb)] = (tr, tg, tb)

		v["palette"] = palette

	# List parts
	for file in os.listdir("parts"):
		k = re.search(regex, file)
		if k:
			parts[k.group(1)] = {}

	# Load parts
	for k, v in parts.items():
		print("Loading part:", k)
		maskFile = "parts/" + k + "_mask.png"
		v["mask"] = Image.open(maskFile).convert("RGBA") if os.path.isfile(maskFile) else None
		v["overlay"] = Image.open("parts/" + k + "_overlay.png")

	# Load tools
	for file in os.listdir("tools"):
		k = os.path.splitext(file)[0]
		print("Loading tool:", k)
		tools[k] = yaml.safe_load(open("tools/" + file))

	# Generate
	for tk, tool in tools.items():
		toolParts = tool["parts"]

		for comb in itertools.product(materials.keys(), repeat=len(toolParts)):
			img = Image.new("RGBA", (32, 32))

			name = tk

			for pix, mk in enumerate(comb):
				name += "__" + toolParts[pix] + "_" + mk

			print("Generating: ", name)

			for pix, mk in enumerate(comb):
				part = parts[toolParts[pix]]
				material = materials[mk]

				mask = part["mask"]
				if mask != None:
					tex = material["tex1"].copy()
					texp = tex.load()
				
					for y in range(tex.height):
						for x in range(tex.width):
							r, g, b, a = texp[x, y]
							mp = mask.getpixel((x, y))
							a = math.floor(a * mp[3] / 255)
							texp[x, y] = (r, g, b, a)

					img = Image.alpha_composite(img, tex)
					# tex.save("out/" + name + "_" + str(pix) + "1.png")

				tex = part["overlay"].copy()
				texp = tex.load()
				palette = material["palette"]

				for y in range(tex.height):
					for x in range(tex.width):
						r, g, b, a = texp[x, y]
						(r, g, b) = palette.get((r, g, b), (r, g, b))
						texp[x, y] = (r, g, b, a)

				img = Image.alpha_composite(img, tex)
				# tex.save("out/" + name + "_" + str(pix) + "2.png")

			img.save("out/" + name + ".png")

				

main()