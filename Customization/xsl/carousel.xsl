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
  <!-- Customization to add Bootstrap Carousel Component -->
  <!-- https://getbootstrap.com/docs/5.3/components/carousel/ -->

  <xsl:template
    match="*[ (contains(@class,' topic/ul ') or contains(@class, ' topic/ol ')) and contains(@outputclass, 'carousel')]"
  >
    <xsl:variable name="id">
      <xsl:value-of select="concat('carousel_' ,dita-ot:generate-html-id(.))"/>
    </xsl:variable>
    <div data-bs-ride="carousel">
      <xsl:attribute name="id" select="$id"/>
      <xsl:call-template name="commonattributes"/>
      <div class="carousel-inner">
        <xsl:apply-templates mode="carousel"/>
      </div>
      <a class="carousel-control-prev" role="button" data-bs-slide="prev">
        <xsl:attribute name="data-bs-target" select="concat('#' , $id)"/>
        <span class="carousel-control-prev-icon" aria-hidden="true"/>
        <span class="visually-hidden">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Previous'"/>
          </xsl:call-template>
        </span>
      </a>
      <a class="carousel-control-next" role="button" data-bs-slide="next">
        <xsl:attribute name="data-bs-target" select="concat('#' , $id)"/>
        <span class="carousel-control-next-icon" aria-hidden="true"/>
        <span class="visually-hidden">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Next'"/>
          </xsl:call-template>
        </span>
      </a>
    </div>
  </xsl:template>

  <!-- Carousel Items, Slides only -->
  <xsl:template match="*[contains(@class,' topic/li ')]" mode="carousel">
    <div>
      <xsl:attribute name="class">
        <xsl:text>carousel-item</xsl:text>
        <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/li ')]) = 0">
          <xsl:text> active</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:apply-templates select="*" mode="carousel"/>
    </div>
  </xsl:template>

  <!-- Carousel Items Slides with Captions -->
  <xsl:template match="*[contains(@class,' topic/fig ')]" mode="carousel">
    <xsl:apply-templates select="*[contains(@class,' topic/image ')]" mode="carousel"/>
    <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="carousel"/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/image ')]" mode="carousel">
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
    <img>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="'d-block w-100'"/>
      </xsl:call-template>
      <xsl:call-template name="setid"/>
      <xsl:choose>
        <xsl:when test="*[contains(@class, ' topic/longdescref ')]">
          <xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@longdescref"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@href|@height|@width"/>
      <xsl:apply-templates select="@scale"/>
      <xsl:choose>
        <xsl:when test="*[contains(@class, ' topic/alt ')]">
          <xsl:variable name="alt-content">
            <xsl:apply-templates select="*[contains(@class, ' topic/alt ')]" mode="text-only"/>
          </xsl:variable>
          <xsl:attribute name="alt" select="normalize-space($alt-content)"/>
        </xsl:when>
        <xsl:when test="@alt">
          <xsl:attribute name="alt" select="@alt"/>
        </xsl:when>
      </xsl:choose>
    </img>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  </xsl:template>

  <!-- Slide Caption -->
  <xsl:template match="*[contains(@class,' topic/title ')]" mode="carousel">
    <div class="carousel-caption d-none d-md-block">
      <p>
        <xsl:call-template name="commonattributes"/>
        <xsl:value-of select="."/>
      </p>
    </div>
  </xsl:template>
</xsl:stylesheet>
