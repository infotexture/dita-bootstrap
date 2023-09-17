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

  <xsl:template name="scrollspy-content">
    <xsl:choose>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('list-group')">
        <div class="list-group me-3" id="bs-scrollspy">
          <xsl:apply-templates mode="scrollspy"/>
        </div>
      </xsl:when>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('nav-pill')">
        <nav class="nav nav-pills flex-column navbar-light bg-body-tertiary" id="bs-scrollspy">
          <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'yes'">
            <xsl:attribute name="dir" select="'rtl'"/>
          </xsl:if>
          <xsl:apply-templates mode="scrollspy"/>
        </nav>
      </xsl:when>
      <xsl:otherwise>
        <nav>
          <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'yes'">
            <xsl:attribute name="dir" select="'rtl'"/>
          </xsl:if>
          <ul>
            <xsl:apply-templates mode="scrollspy"/>
          </ul>
        </nav>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

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
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('list-group')">
        <xsl:apply-templates mode="scrollspy"/>
      </xsl:when>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('nav-pill')">
        <nav class="nav nav-pills flex-column ps-3">
          <xsl:apply-templates mode="scrollspy"/>
        </nav>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:apply-templates mode="scrollspy"/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/title ')]" mode="scrollspy">
    <xsl:choose>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('list-group')">
        <a class="list-group-item list-group-item-action">
          <xsl:call-template name="scrollspy-href"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('nav-pill')">
        <a class="my-1 ps-2 nav-link">
          <xsl:call-template name="scrollspy-href"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <a class="ps-2">
            <xsl:call-template name="scrollspy-href"/>
            <xsl:apply-templates/>
          </a>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="scrollspy"/>
</xsl:stylesheet>
