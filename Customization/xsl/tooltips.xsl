<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="xs xhtml dita-ot"
>
  <!-- Customization to add Bootstrap Tooltips Component -->
  <!-- https://getbootstrap.com/docs/5.0/components/tooltips/ -->


   <xsl:template match="*" mode="add-bootstrap-tooltip">
    <xsl:attribute name="data-bs-toggle">
      <xsl:text>tooltip</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="data-bs-placement">
      <xsl:choose>
        <xsl:when test="contains(@outputclass, 'tooltip-left')">
          <xsl:text>left</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@outputclass, 'tooltip-right')">
          <xsl:text>right</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@outputclass, 'tooltip-bottom')">
          <xsl:text>bottom</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>top</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:choose>
      <xsl:when test="*[contains(@class, ' topic/desc ')]/*">
        <xsl:attribute name="data-bs-html">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:apply-templates select="*[contains(@class, ' topic/desc ')][1]" mode="tooltipdesc"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="add-desc-as-hoverhelp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="*[contains(@class, ' topic/desc ')]" mode="tooltipdesc">
    <xsl:for-each select="*|text()">
      <xsl:choose>
        <xsl:when test="contains(@class,' hi-d/b ')">
          <xsl:text>&lt;strong&gt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&lt;/strong&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@class,' hi-d/i ')">
          <xsl:text>&lt;em&gt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&lt;/em&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@class,' hi-d/u ')">
          <xsl:text>&lt;u&gt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&lt;/u&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@class,' hi-d/tt ')">
          <xsl:text>&lt;tt&gt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&lt;/tt&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@class,' hi-d/sup ')">
          <xsl:text>&lt;sup&gt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&lt;/sup&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@class,' hi-d/sub ')">
          <xsl:text>&lt;sub&gt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&lt;/sub&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@class,' hi-d/line-through ')">
          <xsl:text>&lt;span style="text-decoration:line-through"&gt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&lt;/span&gt;</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@class,' hi-d/overline ')">
          <xsl:text>&lt;span style="text-decoration:overline"&gt;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>&lt;/span&gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!--template for xref-->
  <xsl:template match="*[contains(@class, ' topic/xref ') and contains(@outputclass, 'tooltip-')]" name="topic.xref">
    <xsl:choose>
      <xsl:when test="@href and normalize-space(@href)">
        <a>
          <!-- ↓ Add Bootstrap class attributes template ↑ -->
          <xsl:apply-templates select="." mode="add-bootstrap-tooltip"/>
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates select="." mode="add-linking-attributes"/>
          <!-- if there is text or sub element other than desc, apply templates to them
          otherwise, use the href as the value of link text. -->
          <xsl:choose>
            <xsl:when test="@type = 'fn'">
              <sup>
                <xsl:choose>
                  <xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
                    <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                    <!--use xref content-->
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="href"/><!--use href text-->
                  </xsl:otherwise>
                </xsl:choose>
              </sup>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
                  <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                  <!--use xref content-->
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="href"/><!--use href text-->
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </a>
        <xsl:apply-templates select="." mode="add-xref-highlight-at-end"/>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="commonattributes"/>
          <!-- ↓ Add Bootstrap class attributes template ↑ -->
          <xsl:apply-templates select="." mode="add-bootstrap-tooltip"/>
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
