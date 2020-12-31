# PlantUML Redmine plugin

This plugin will allow adding [PlantUML](http://plantuml.sourceforge.net/) diagrams into Redmine.

## Requirements

- Java
- PlantUML binary

## Installation

- create a shell script in `/usr/bin/plantuml`

```
#!/bin/bash
/usr/bin/java -Djava.io.tmpdir=/var/tmp -Djava.awt.headless=true -jar /PATH_TO_YOUR_PLANTUML_BINARY/plantuml.jar ${@}
```

- copy this plugin into the Redmine plugins directory

## Usage

- go to the [plugin settings page](http://localhost:3000/settings/plugin/plantuml) and add the *PlantUML binary* path `/usr/bin/plantuml`
- PlantUML diagrams can be added as follow:

```
{{plantuml(png)
  Bob -> Alice : hello
}}
```

```
{{plantuml(svg)
  Bob -> Alice : hello
}}
```

- you can choose between PNG or SVG images by setting the `plantuml` macro argument to either `png` or `svg`

- a special format `inline_svg` can be used to embedd svg into html page. With embedded svg's it's possible tu use hyperlinks to navigate to wiki pages from the diagram (see http://plantuml.sourceforge.net/qa/?qa=90/web-links-in-generated-images-e-g-using-image-maps for details). For example:

```
{{plantuml(inline_svg)
  Bob -> Alice : hello [[https://github.com/dkd/plantuml{Thanks Michael Skrynski} rendered by plantuml plugin]]
}}
```

## using !include params

Since all files are written out to the system, there is no safe way to prevent editors from using the `!include` command inside the code block.
Therefore every input will be sanitited before writing out the .pu files for further interpretation. You can overcome this by activating the `Setting.plugin_plantuml['allow_includes']`
**Attention**: this is dangerous, since all files will become accessible on the host system.

## Known issues

- PlantUML diagrams are not rendered inside a PDF export, see https://github.com/dkd/plantuml/issues/1

## TODO

- add image caching
