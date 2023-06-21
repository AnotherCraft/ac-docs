# Hive

Hive is basically a global associative array `Identifier -> Variant` that's used to store configuration for the client.

* All hive data is accessible from QML through `hive[key]`  and can be also changed from the QML.
* There is a set of QML controls that are dynamically linked with hive keys (`HiveCheckBox, HiveSlider, HiveComboBox` and so on).
* Hive is automatically synchronized with `hive.json` on the disk – it's persistent across game runs.
* Hive utilizes `DynamicVariable` classes so that values from it can be for example dynamically linked with `GPUShader` defines, making the shader automatically update when the hive variable changes.