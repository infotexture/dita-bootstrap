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
  <!-- Customization to add Bootstrap Scrollspy Component -->
  <!-- https://getbootstrap.com/docs/5.3/components/scrollspy/ -->

  <xsl:template match="*" mode="scrollspy-href">
    <xsl:call-template name="scrollspy-href"/>
  </xsl:template>

  <xsl:template name="scrollspy-href">
    <xsl:attribute name="href">
      <xsl:text>#</xsl:text>
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:sequence select="dita-ot:generate-id(parent::*/@id, @id)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>ariaid-title</xsl:text>
          <xsl:number
            count="*[contains(@class, ' topic/title ')][parent::*[contains(@class,' topic/topic ')]]"
            level="any"
          />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="scrollspy">
    <xsl:choose>
      <xsl:when test="$nav-toc = ('list-group-scrollspy')">
        <xsl:apply-templates mode="scrollspy"/>
      </xsl:when>
      <xsl:when test="$nav-toc = ('nav-pill-scrollspy')">
        <nav class="nav nav-pills flex-column ps-3">
          <xsl:apply-templates mode="scrollspy"/>
        </nav>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/title ')]" mode="scrollspy">
    <xsl:choose>
      <xsl:when test="$nav-toc = ('list-group-scrollspy')">
        <a class="list-group-item list-group-item-action">
          <xsl:call-template name="scrollspy-href"/>
          <xsl:apply-templates mode="scrollspy"/>
        </a>
      </xsl:when>
      <xsl:when test="$nav-toc = ('nav-pill-scrollspy')">
        <a class="my-1 nav-link">
          <xsl:call-template name="scrollspy-href"/>
          <xsl:apply-templates mode="scrollspy"/>
        </a>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="scrollspy"/>
</xsl:stylesheet>
