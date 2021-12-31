<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2017 · infotexture · Roger W. Fienhold Sheen -->
<!-- See the accompanying LICENSE file for applicable license -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  version="2.0"
  exclude-result-prefixes="xs dita-ot"
>
  <!-- the file name containing XHTML to be placed in the HEAD area
       (file name and extension only - no path). -->
  <xsl:param name="BOOTSTRAP_ICONS_CDN"/>
  <!-- Whether include bootstrap icons.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_ICONS_INCLUDE" select="'no'"/>

  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5.xsl"/>

  <xsl:include href="../Customization/xsl/accordion.xsl"/>
  <xsl:include href="../Customization/xsl/card.xsl"/>
  <xsl:include href="../Customization/xsl/carousel.xsl"/>
  <xsl:include href="../Customization/xsl/offcanvas.xsl"/>
  <xsl:include href="../Customization/xsl/hi-d.xsl"/>
  <xsl:include href="../Customization/xsl/nav.xsl"/>
  <xsl:include href="../Customization/xsl/tabs.xsl"/>
  <xsl:include href="../Customization/xsl/tables.xsl"/>
  <xsl:include href="../Customization/xsl/topic.xsl"/>
  <xsl:include href="../Customization/xsl/tooltips.xsl" />
  <xsl:include href="../Customization/xsl/utility-classes.xsl"/>

  <!-- Override to add <meta> elements to page heads -->
  <xsl:template match="*" mode="chapterHead">
    <head>
      <!-- initial meta information -->
      <xsl:call-template name="generateCharset"/>   <!-- Set the character set to UTF-8 -->
      <!-- ↓ Add <meta> element from Bootstrap starter template ↓ -->
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="generateDefaultCopyright"/> <!-- Generate a default copyright, if needed -->
      <xsl:call-template name="generateDefaultMeta"/> <!-- Standard meta for security, robots, etc -->
      <xsl:call-template name="getMeta"/>           <!-- Process metadata from topic prolog -->
      <xsl:call-template name="copyright"/>         <!-- Generate copyright, if specified manually -->
      <xsl:call-template name="generateChapterTitle"/> <!-- Generate the <title> element -->
      <xsl:call-template name="gen-user-head"/>    <!-- include user's XSL HEAD processing here -->
      <xsl:call-template name="gen-user-scripts"/> <!-- include user's XSL javascripts here -->
      <xsl:call-template name="processHDF"/>        <!-- Add user HDF file, if specified -->
      <xsl:call-template name="generateCssLinks"/>  <!-- Generate links to CSS files -->
      <xsl:call-template name="gen-user-styles"/>   <!-- include user's XSL style element and content here -->

      <!-- Add Bootstrap icons -->
      <xsl:if test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
        <!--Check the file Url Definition of HDF HDR FTR-->
        <xsl:variable name="BOOTSTRAP_CDNFILE">
          <xsl:choose>
            <xsl:when test="not($BOOTSTRAP_ICONS_CDN)"/> <!-- If no filterfile leave empty -->
            <xsl:when test="starts-with($BOOTSTRAP_ICONS_CDN, 'file:')">
              <xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="starts-with($BOOTSTRAP_ICONS_CDN, '/')">
                  <xsl:text>file://</xsl:text><xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>file:/</xsl:text><xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="string-length($BOOTSTRAP_CDNFILE) > 0">
          <xsl:copy-of select="document($BOOTSTRAP_CDNFILE, /)"/>
        </xsl:if>
      </xsl:if>
    </head>
  </xsl:template>

  <!-- Override to add Bootstrap container & row to page -->
  <!-- https://getbootstrap.com/docs/5.0/layout/grid -->
  <xsl:template match="*" mode="chapterBody">
    <body>
      <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
      <xsl:call-template name="setaname"/>  <!-- For HTML4 compatibility, if needed -->
      <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>

      <!-- ↓ Add Bootstrap container & row -->
      <div class="container" id="content">
        <div class="row">
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
          <xsl:call-template name="gen-user-sidetoc"/>
          <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
      <!-- ↓ Close Bootstrap divs -->
        </div>
      </div>

      <script language="javascript">//
        <![CDATA[
          var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
          var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
          })
       // ]]>
     </script>
      <!-- ↑ End customization -->
      <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
    </body>
  </xsl:template>

  <!-- Override to add Bootstrap large grid classes. -->
  <!-- https://getbootstrap.com/docs/5.0/layout/grid -->
  <xsl:attribute-set name="main">
    <xsl:attribute name="class">col-lg-9</xsl:attribute>
    <xsl:attribute name="role">main</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="toc">
    <xsl:attribute name="class">col-lg-3</xsl:attribute>
    <xsl:attribute name="role">navigation</xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
