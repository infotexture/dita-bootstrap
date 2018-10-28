<?xml version="1.0" encoding="UTF-8"?>

<!-- Copyright © 2017 · infotexture · Roger W. Fienhold Sheen -->
<!-- See the accompanying LICENSE file for applicable license -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                version="2.0"
                exclude-result-prefixes="xs dita-ot">

  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5.xsl"/>

  <!-- ========== DEFAULT PAGE LAYOUT ========== -->

  <xsl:template name="chapter-setup">
    <html>
      <xsl:call-template name="setTopicLanguage"/>
      <xsl:call-template name="chapterHead"/>
      <xsl:call-template name="chapterBody"/>
    </html>
  </xsl:template>

  <!-- Override to add <meta> elements to page heads -->
  <xsl:template match="*" mode="chapterHead">
    <head>
      <!-- initial meta information -->
      <xsl:call-template name="generateCharset"/>   <!-- Set the character set to UTF-8 -->
      <!-- ↓ Add <meta> elements from basic Bootstrap template -->
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="generateDefaultCopyright"/> <!-- Generate a default copyright, if needed -->
      <xsl:call-template name="generateDefaultMeta"/> <!-- Standard meta for security, robots, etc -->
      <xsl:call-template name="getMeta"/>           <!-- Process metadata from topic prolog -->
      <xsl:call-template name="copyright"/>         <!-- Generate copyright, if specified manually -->
      <xsl:call-template name="generateCssLinks"/>  <!-- Generate links to CSS files -->
      <xsl:call-template name="generateChapterTitle"/> <!-- Generate the <title> element -->
      <xsl:call-template name="gen-user-head" />    <!-- include user's XSL HEAD processing here -->
      <xsl:call-template name="gen-user-scripts" /> <!-- include user's XSL javascripts here -->
      <xsl:call-template name="gen-user-styles" />  <!-- include user's XSL style element and content here -->
      <xsl:call-template name="processHDF"/>        <!-- Add user HDF file, if specified -->
    </head>
  </xsl:template>

  <!-- Override to add <main> element to body content -->
  <xsl:template match="*" mode="chapterBody">
    <body>
      <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
      <xsl:call-template name="setaname"/>  <!-- For HTML4 compatibility, if needed -->
      <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>

      <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
      <xsl:call-template name="gen-user-sidetoc"/>
      <!-- ↓ Wrap body content in <main> element with Bootstrap classes -->
      <main id="content" class="col-md-9 container" role="main">
        <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
      </main>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
    </body>
  </xsl:template>

  <!-- Override to add Bootstrap navbar -->
  <xsl:template match="/|node()|@*" mode="gen-user-header">
    <!-- to customize: copy this to your override transform, add the content you want. -->
    <!-- it will be placed in the running heading section of the XHTML. -->
    <!-- ↓ Add static navbar with Bootstrap classes -->
    <div class="navbar navbar-default navbar-static-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".bs-navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="/">DITA Bootstrap</a>
        </div>
        <div class="collapse navbar-collapse bs-navbar-collapse">
          <ul class="nav navbar-nav">
            <li><a href="#">Link One</a></li>
            <li><a href="#">Link Two</a></li>
            <li><a href="#">Link Three</a></li>
          </ul>
        </div>
      </div>
    </div>
    <!-- ↑ End customization -->
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
    </main>
  </xsl:template>

  <xsl:template match="*" mode="gen-user-sidetoc">
    <xsl:if test="$nav-toc = ('partial', 'full')">
      <nav class="col-md-3" role="toc">
        <div class="well well-sm">
          <ul class="bs-docs-sidenav">
            <xsl:choose>
              <xsl:when test="$nav-toc = 'partial'">
                <xsl:apply-templates select="$current-topicrefs[1]" mode="toc-pull">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                  <xsl:with-param name="children" as="element()*">
                    <xsl:apply-templates select="$current-topicrefs[1]/*[contains(@class, ' map/topicref ')]" mode="toc">
                      <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:when test="$nav-toc = 'full'">
                <xsl:apply-templates select="$input.map" mode="toc">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                </xsl:apply-templates>
              </xsl:when>
            </xsl:choose>
          </ul>
        </div>
      </nav>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
