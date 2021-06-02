# DITA Bootstrap

A plug-in for [DITA Open Toolkit][1] that extends the default HTML5 output with a basic [Bootstrap][2] template.

<!-- MarkdownTOC levels="1,2" -->

- [DITA Bootstrap](#dita-bootstrap)
  - [Installing](#installing)
  - [Using](#using)
  - [Customizing](#customizing)
    - [Header menu](#header-menu)
    - [Custom CSS](#custom-css)
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
dita --input=path/to/your.ditamap --format=html5-bootstrap
```

## Customizing

### Header menu

The plug-in includes a default static navbar with a project name and global links. To override the global navigation with a header of your own, pass a custom header file to the `dita` command via the `--args.hdr` parameter:

```console
dita --input=path/to/your.ditamap --format=html5-bootstrap \
     --args.hdr=path/to/your-header.xml
```

The plug-in includes a sample [header alternative with a dark navbar][3].

Edit a copy of this file to adjust the content of the global navigation.

### Custom CSS

Bootstrap themes can be generated using the [Themestr.app](https://themestr.app/theme). The plug-in includes a sample placeholder for [custom CSS][4] styles. You can edit this file to add style rules of your own. Override the default Bootstrap theme by passing a custom CSS file to the `dita` command via the `--args.css` parameter:

```console
dita --input=path/to/your.ditamap --format=html5-bootstrap \
     --args.hdr=path/to/your-header.xml \
     --args.css=<name-of-css>.css \
     --args.copycss=yes \
     --args.csspath=css \
     --args.cssroot=path/to/your/theme
```

![Sample DITA Bootstrap output](images/custom-bootstrap.png)

For more extensive customizations, you may want to [fork][5] this repository and create a new plug-in of your own.

You can add your own XSLT customizations by creating a new plug-in that extends the DITA Bootstrap XSLT transforms. Just amend `args.xsl` to point to your own XSLT files. An [XSLT template](./xsl/html5-bootstrap-template.xsl) is included within this repository.

## Feedback

- If you find this useful and build something of your own on top of it, [let me know][6].

- If you find a bug or would like to suggest a change, [create an issue][7].  
  _(If it's a bug, provide steps to recreate the issue.)_

- If you know how to fix it yourself, [submit a pull request][8] with the proposed changes.

## License

[Apache 2.0](LICENSE) © 2017 - 2021 Roger W. Fienhold Sheen

Within the sample documentation, where necessary, the texts describing the usage of each component have been copied directly from the official [Bootstrap 5.0 documentation][9], however DITA markup is used throughout the examples describing how to implement these components correctly using `outputclass`.

[1]: http://www.dita-ot.org
[2]: https://getbootstrap.com/docs/5.0
[3]: https://github.com/infotexture/dita-bootstrap/blob/master/includes/bs-navbar-inverse.hdr.xml
[4]: https://github.com/infotexture/dita-bootstrap/blob/master/css/custom.css
[5]: https://help.github.com/articles/fork-a-repo/
[6]: https://twitter.com/infotexture
[7]: https://github.com/infotexture/dita-bootstrap/issues/new
[8]: https://help.github.com/articles/using-pull-requests/
[9]: https://getbootstrap.com/docs/5.0
