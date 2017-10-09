<?xml version="1.0" encoding="UTF-8"?>

<!-- Copyright © 2017 · infotexture · Roger W. Fienhold Sheen -->
<!-- See the accompanying LICENSE file for applicable license -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                version="2.0"
                exclude-result-prefixes="xs dita-ot">

  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5.xsl"/>

  <xsl:template name="chapter-setup">
    <html>
      <xsl:call-template name="setTopicLanguage"/>
      <xsl:value-of select="$newline"/>
      <xsl:call-template name="chapterHead"/>
      <xsl:call-template name="chapterBody"/>
    </html>
  </xsl:template>

  <xsl:template match="*" mode="chapterHead">
    <xsl:variable name="textTitle">
      <xsl:apply-templates select="/*/*[contains(@class,' topic/title ')]" mode="text-only"/>
    </xsl:variable>
    <xsl:variable name="textShortdesc">
      <xsl:apply-templates select="/*/*[contains(@class,' topic/shortdesc ')]" mode="text-only"/>
    </xsl:variable>
    <xsl:variable name="siteIcon" select="'http://metadita.org/puffinHead.png'"/>
    <xsl:variable name="largerSiteImage" select="'http://metadita.org/puffinFull.png'"/>
    <head>
      <meta charset="utf-8"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <meta name="description" content=""/>
      <meta name="author" content="Robert D. Anderson"/>
      <meta name="twitter:card" content="summary" />
      <meta name="twitter:site" content="@robander" />
      <meta name="twitter:title" content="{$textTitle}" />
      <meta name="twitter:description" content="{$textShortdesc}" />
      <meta name="twitter:image" content="{$largerSiteImage}" />
      <meta property="og:type" content="article"/>
      <meta property="og:image" content="{$largerSiteImage}"/>
      <meta property="og:site_name" content="MetaDITA"/>
      <meta property="og:locale" content="en_US"/>
      <meta property="og:title" content="{$textTitle}"/>
      <meta property="og:description" content="{$textShortdesc}"/>

      <link rel="shortcut icon" href="{$siteIcon}"/>

      <title><xsl:value-of select="$textTitle"/></title>

      <!-- Bootstrap core CSS -->
      <link href="/css/bootstrap.min.css" rel="stylesheet"/>
      <link href="/css/basics.css" rel="stylesheet"/>
      <style>
.cmdname, .filepath {
  font-family: monospace;
}</style>

    </head>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="*" mode="chapterBody">
    <body>
      <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>

      <div class="navbar navbar-inverse navbar-static-top" role="navigation">
        <div class="container">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/">MetaDITA</a>
          </div>
          <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
              <li><a href="/">Home</a></li>
              <li class="active"><a href="/toolkit/">DITA Thoughts</a></li>
              <li><a href="/music/">Music of DITA</a></li>
              <li><a href="/books/">Books</a></li>
              <li><a href="/presentations.html">Presentations</a></li>
              <li><a href="/catfurniture.html">Cats</a></li>
            </ul>
          </div>
        </div>
      </div>


      <div class="container">
        <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
      </div>
    </body>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="*" mode="addContentToHtmlBodyElement">
    <main role="main">
      <article role="article">
        <xsl:attribute name="aria-labelledby">
          <xsl:apply-templates select="*[contains(@class,' topic/title ')] |
            self::dita/*[1]/*[contains(@class,' topic/title ')]" mode="return-aria-label-id"/>
        </xsl:attribute>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
        <xsl:apply-templates/> <!-- this will include all things within topic; therefore, -->
        <!-- title content will appear here by fall-through -->
        <!-- followed by prolog (but no fall-through is permitted for it) -->
        <!-- followed by body content, again by fall-through in document order -->
        <!-- followed by related links -->
        <!-- followed by child topics by fall-through -->
        <xsl:call-template name="gen-endnotes"/>    <!-- include footnote-endnotes -->
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
      </article>
      <aside>
        <div class="familylinks">
          <div class="parentlink"><strong>Parent topic:</strong> <a class="link" href="index.html" title="In which are collected a few random ideas and articles about DITA, DITA-OT, and possibly related subjects.">Thoughts on DITA and DITA-OT</a></div>
        </div>
      </aside>
    </main>
  </xsl:template>

</xsl:stylesheet>
