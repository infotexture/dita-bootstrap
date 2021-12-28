# DITA Bootstrap

A plug-in for [DITA Open Toolkit][1] that extends the default HTML5 output with a basic [Bootstrap][2] template.

<!-- MarkdownTOC levels="2,3" -->

- [Installing](#installing)
- [Using](#using)
- [Customizing](#customizing)
  - [Headers and footers](#headers-and-footers)
  - [Navigation menu](#navigation-menu)
  - [Custom CSS](#custom-css)
  - [Common Bootstrap utility classes](#common-bootstrap-utility-classes)
- [Feedback](#feedback)
- [License](#license)

<!-- /MarkdownTOC -->

![Sample DITA Bootstrap output](images/default-bootstrap.png)

## Installing

Use the `dita` command to add this plug-in to your DITA Open Toolkit installation:

DITA-OT 3.5 and newer:

```console
dita install fox.jason.extend.css
dita install net.infotexture.dita-bootstrap
```

DITA-OT 3.3 and newer:

```console
dita --install fox.jason.extend.css
dita --install net.infotexture.dita-bootstrap
```

DITA-OT 3.2 and older:

```console
dita --install \
       https://github.com/jason-fox/fox.jason.extend.css/archive/master.zip
dita --install \
       https://github.com/infotexture/dita-bootstrap/archive/master.zip
```

## Using

Specify the `html5-bootstrap` format when building output with the `dita` command:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap
```

## Customizing

### Headers and footers

The plug-in includes a default static navigation menu with a project name and global link placeholders.

The default header file `includes/bs-navbar-default.hdr.xml` uses the Bootstrap primary (blue) background color for the [navbar component][3].

To change the color to a dark (black) background, replace the primary background color class `bg-primary` on the first line with the dark variant `bg-dark`:

```diff
- <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
+ <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
```

You can edit a copy of this file to adjust the content of the global navigation. To override the global navigation with your own header, pass a custom header file to the `dita` command via the `--args.hdr` parameter:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --args.hdr=path/to/your-header.xml
```

The plug-in includes a sample [header alternative with a light navbar][4].

No footer is added by default, but the plug-in also includes a sample [footer file][5]. To add a footer to the generated output, pass a custom footer file to the `dita` command via the `--args.ftr` parameter:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --args.ftr=path/to/your-footer.xml
```

### Navigation menu

The plug-in extends the standard HTML5 table of contents (ToC) [navigation parameter][6] `--nav-toc` to add styled list groups to the navigation menu. (The navigation is rendered as a sidebar in desktop browsers and above the content on smaller devices.)

By default, the plug-in uses the `partial` option to include the current topic in the ToC along with its parents, siblings and children. As with the default HTML5 plug-in, the `full` option can also be used to generate a complete ToC for the entire map, or `none` to disable the table of contents entirely.

As of version 5.3, the plug-in provides two new options to style the table of contents navigation with the Bootstrap [list group][7] component.

- `list-group-full` – Styled full ToC within a Bootstrap list group
- `list-group-partial` – Partial ToC with the current topic, parents, siblings, and children in a list group

To use these options, pass the desired value to the `dita` command via the `--nav-toc` parameter:

```console
dita --input=path/to/your.ditamap \
     --format=html5-bootstrap \
     --nav-toc=list-group-partial
```

For an example of the `list-group-full` styling, see the output at https://infotexture.github.io/dita-bootstrap/.

### Custom CSS

Bootstrap themes can be generated using the [Themestr.app](https://themestr.app/theme). The plug-in includes a sample placeholder for [custom CSS][8] styles. You can edit this file to add style rules of your own. Override the default Bootstrap theme by passing a custom CSS file to the `dita` command via the `--args.css` parameter:

```console
dita --input=path/to/your.ditamap --format=html5-bootstrap \
     --args.hdr=path/to/your-header.xml \
     --args.css=<name-of-css>.css \
     --args.copycss=yes \
     --args.csspath=css \
     --args.cssroot=path/to/your/theme
```

![Sample DITA Bootstrap output](images/custom-bootstrap.png)

For more extensive customizations, you may want to [fork][9] this repository and create a new plug-in of your own.

You can add your own XSLT customizations by creating a new plug-in that extends the DITA Bootstrap XSLT transforms. Just amend `args.xsl` to point to your own XSLT files. An [XSLT template](./xsl/html5-bootstrap-template.xsl) is included within this repository.

### Common Bootstrap utility classes

The HTML output for the following DITA elements can be annotated with common Bootstrap utility classes for borders, background, text, spacing, etc. using additional command line parameters:

- `bootstrap.css.shortdesc` – common Bootstrap utility classes for DITA `<shortdesc>` elements
- `bootstrap.css.codeblock` – common Bootstrap utility classes for DITA `<codeblock>` elements
- `bootstrap.css.header` – common Bootstrap utility classes for DITA `<title>` elements
- `bootstrap.css.card` – common utility classes for Bootstrap card components
- `bootstrap.css.carousel` – common utility classes for Bootstrap carousel components
- `bootstrap.css.carousel.caption` – common utility classes for Bootstrap carousel captions
- `bootstrap.css.tabs` – common utility classes for Bootstrap tabbed dialog components
- `bootstrap.css.tabs.vertical` – common utility classes for Bootstrap vertical tabbed dialog components
- `bootstrap.css.accordion` – common utility classes for Bootstrap accordion components

## Feedback

- If you find this useful and build something of your own on top of it, [let me know][10].

- If you find a bug or would like to suggest a change, [create an issue][11].  
  _(If it’s a bug, provide steps to recreate the issue.)_

- If you know how to fix it yourself, [submit a pull request][12] with the proposed changes.

## License

[Apache 2.0](LICENSE) © 2017–2021 Roger W. Fienhold Sheen

Within the sample documentation, where necessary, the texts describing the usage of each component have been copied directly from the official [Bootstrap 5.0 documentation][2], however DITA markup is used throughout the examples describing how to implement these components correctly using `outputclass`.

[1]: http://www.dita-ot.org
[2]: https://getbootstrap.com/docs/5.0
[3]: https://getbootstrap.com/docs/5.0/examples/navbars/
[4]: https://github.com/infotexture/dita-bootstrap/blob/develop/includes/bs-navbar-light.hdr.xml
[5]: https://github.com/infotexture/dita-bootstrap/blob/develop/includes/bs-footer-example.xml
[6]: https://www.dita-ot.org/dev/parameters/parameters-html5.html#html5__nav-toc
[7]: https://getbootstrap.com/docs/5.0/components/list-group/
[8]: https://github.com/infotexture/dita-bootstrap/blob/develop/css/custom.css
[9]: https://help.github.com/articles/fork-a-repo/
[10]: https://twitter.com/infotexture
[11]: https://github.com/infotexture/dita-bootstrap/issues/new
[12]: https://help.github.com/articles/using-pull-requests/
