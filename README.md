# DITA Bootstrap

A plug-in for [DITA Open Toolkit][1] that extends the default HTML5 output with a basic [Bootstrap][2] template.

<!-- MarkdownTOC levels="1,2" -->

- [Installing](#installing)
- [Using](#using)
- [Customizing](#customizing)
- [Feedback](#feedback)

<!-- /MarkdownTOC -->

![Sample DITA Bootstrap output](images/dita-bootstrap-default-screenshot.png)

## Installing

Use the `dita` command to add this plug-in to your DITA Open Toolkit installation:

DITA-OT 3.5 and newer:

    dita install net.infotexture.dita-bootstrap

DITA-OT 3.3 and newer:

    dita --install net.infotexture.dita-bootstrap

DITA-OT 3.2 and older:

    dita --install https://github.com/infotexture/dita-bootstrap/archive/3.1.zip

## Using

Specify the `html5-bootstrap` format when building output with the `dita` command:

    dita --input=path/to/your.ditamap --format=html5-bootstrap

## Customizing

### Header menu

The plug-in includes a default static navbar with a project name and global links. To override the global navigation with a header of your own, pass a custom header file to the `dita` command via the `--args.hdr` parameter:

    dita --input=path/to/your.ditamap --format=html5-bootstrap \
         --args.hdr=path/to/your-header.xml

The plug-in includes a sample [header alternative with a dark navbar][3].

Edit a copy of this file to adjust the content of the global navigation.

### Custom CSS

The plug-in includes a basic placeholder for [custom CSS][4] styles. You can edit this file to add style rules of your own, or override it by passing a custom CSS file to the `dita` command via the `--args.css` parameter:

    dita --input=path/to/your.ditamap --format=html5-bootstrap \
         --args.hdr=path/to/your-header.xml \
         --args.css=path/to/your.css \

For more extensive customizations, you may want to [fork][5] this repository and create a new plug-in of your own.

## Feedback

- If you find this useful and build something of your own on top of it, [let me know][6].

- If you find a bug or would like to suggest a change, [create an issue][7].
  _(If it's a bug, provide steps to recreate the issue.)_

- If you know how to fix it yourself, [submit a pull request][8] with the proposed changes.

[1]: http://www.dita-ot.org
[2]: https://getbootstrap.com/docs/4.5
[3]: https://github.com/infotexture/dita-bootstrap/blob/master/includes/bs-navbar-inverse.hdr.xml
[4]: https://github.com/infotexture/dita-bootstrap/blob/master/css/custom.css
[5]: https://help.github.com/articles/fork-a-repo/
[6]: https://twitter.com/infotexture
[7]: https://github.com/infotexture/dita-bootstrap/issues/new
[8]: https://help.github.com/articles/using-pull-requests/
