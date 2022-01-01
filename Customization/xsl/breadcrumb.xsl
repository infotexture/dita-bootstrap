<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
  version="2.0"
  exclude-result-prefixes="xs dita-ot ditamsg"
>
  <!-- Override to add Bootstrap list-group menu -->
  <!-- https://getbootstrap.com/docs/5.0/components/breadcrumb/ -->

  <xsl:param name="breadcrumb" as="xs:string?"/>

  <!-- Override to add Bootstrap list-group classes -->
  <xsl:template match="*" mode="gen-user-breadcrumb">

    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <xsl:for-each select="ancestor::node()">
          <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
          </xsl:variable>
          <xsl:if test="normalize-space($title)">
            <li class="breadcrumb-item">
              <xsl:choose>
                <xsl:when test="@href">
                  <a>
                    <xsl:attribute name="href" select="@href"/>
                    <xsl:value-of select="$title"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <span>
                    <xsl:value-of select="$title"/>
                  </span>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:if>
        </xsl:for-each>
        <xsl:variable name="title">
          <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>
        <xsl:if test="normalize-space($title)">
          <li class="breadcrumb-item active" aria-current="page">
            <xsl:value-of select="$title"/>
          </li>
        </xsl:if>
      </ol>
    </nav>
  </xsl:template>


</xsl:stylesheet>
