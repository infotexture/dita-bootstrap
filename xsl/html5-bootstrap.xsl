<?xml version="1.0" encoding="UTF-8"?>

<!-- Copyright © 2017 · infotexture · Roger W. Fienhold Sheen -->
<!-- See the accompanying LICENSE file for applicable license -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                version="2.0"
                exclude-result-prefixes="xs dita-ot">

  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5.xsl"/>

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
      <xsl:call-template name="generateChapterTitle"/> <!-- Generate the <title> element -->
      <xsl:call-template name="gen-user-head" />    <!-- include user's XSL HEAD processing here -->
      <xsl:call-template name="gen-user-scripts" /> <!-- include user's XSL javascripts here -->
      <xsl:call-template name="processHDF"/>        <!-- Add user HDF file, if specified -->
      <xsl:call-template name="generateCssLinks"/>  <!-- Generate links to CSS files -->
      <xsl:call-template name="gen-user-styles" />  <!-- include user's XSL style element and content here -->
    </head>
  </xsl:template>

  <!-- Override to add Bootstrap fluid container & row to page body -->
  <!-- https://getbootstrap.com/docs/3.4/css/#grid-example-fluid -->
  <xsl:template match="*" mode="chapterBody">
    <body>
      <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
      <xsl:call-template name="setaname"/>  <!-- For HTML4 compatibility, if needed -->
      <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>

      <!-- ↓ Add Bootstrap fluid container & row -->
      <div class="container-fluid container" id="content">
        <div class="row">
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
          <xsl:call-template name="gen-user-sidetoc"/>
          <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
      <!-- ↓ Close Bootstrap divs -->
        </div>
      </div>
      <!-- ↑ End customization -->
      <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
    </body>
  </xsl:template>

  <!-- Override to add Bootstrap grid class -->
  <!-- https://getbootstrap.com/docs/3.4/css/#grid -->
  <xsl:template match="*" mode="addContentToHtmlBodyElement">
    <!-- ↓ Add grid class -->
    <main class="col-md-9" role="main">
    <!-- ↑ End customization -->
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

  <!-- Override `nav.xsl` to add Bootstrap classes -->
  <xsl:template match="*" mode="gen-user-sidetoc">
    <xsl:if test="$nav-toc = ('partial', 'full')">
      <!-- ↓ Add grid class to <nav>, wrap <ul> in small well <div> & add .bs-docs-sidenav class -->
      <nav class="col-md-3" role="toc">
        <div class="well well-sm">
          <ul class="bs-docs-sidenav">
            <!-- ↑ End customization -->
            <xsl:choose>
              <xsl:when test="$nav-toc = 'partial'">
                <xsl:apply-templates select="$current-topicref" mode="toc-pull">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                  <xsl:with-param name="children" as="element()*">
                    <xsl:apply-templates select="$current-topicref/*[contains(@class, ' map/topicref ')]" mode="toc">
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
        <!-- ↓ Close Bootstrap divs -->
        </div>
        <!-- ↑ End customization -->
      </nav>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
