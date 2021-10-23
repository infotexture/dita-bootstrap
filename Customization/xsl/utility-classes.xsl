<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="xs dita-ot"
>


  <xsl:param name="BOOTSTRAP_CSS_SHORTDESC" select="'text-muted lead'"/>
  <xsl:param name="BOOTSTRAP_CSS_CODEBLOCK" select="'border rounded'"/>
  <xsl:param name="BOOTSTRAP_CSS_HEADER" select="'text-dark'"/>
  <xsl:param name="BOOTSTRAP_CSS_CARD" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_CAROUSEL" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_CAPTION" select="'text-white bg-dark'"/>
  <xsl:param name="BOOTSTRAP_CSS_TABS" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABS_VERTICAL" select="'me-3'"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCORDION" select="''"/>
  <!-- Add a Bootstrap CSS border to codeblocks -->
  <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_CODEBLOCK"/>
  </xsl:template>

  <!-- Enhance the short desc with a Bootstrap CSS lead class -->
  <xsl:template match="*[contains(@class, ' topic/shortdesc ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_SHORTDESC"/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS text color of the headers -->
  <xsl:template match="*[contains(@class, ' topic/title ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_HEADER"/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of cards -->
  <xsl:template
    match="*[contains(@class,' topic/section ') and contains(@outputclass, 'card')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_CARD"/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of carousel -->
  <xsl:template
    match="*[ (contains(@class,' topic/ul ') or contains(@class, ' topic/ol ')) and contains(@outputclass, 'carousel')]"
    mode="get-output-class"
  >
    <xsl:text>slide </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_CAROUSEL"/>
  </xsl:template>

  <!-- Amend the text and background of Figure Captions -->
  <xsl:template
    match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
    priority="5"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_CAPTION"/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of tabs -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-tabs')]"
    mode="get-output-class"
  >
    <xsl:text>nav </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_TABS"/>
  </xsl:template>
  <!-- Change the default Bootstrap CSS classes of tab pills -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-pills')]"
    mode="get-output-class"
  >
    <xsl:text>nav </xsl:text>
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'nav-pills-vertical')">
        <xsl:text>flex-column nav-pills </xsl:text>
        <xsl:value-of select="$BOOTSTRAP_CSS_TABS_VERTICAL"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$BOOTSTRAP_CSS_TABS"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Change the default Bootstrap CSS classes of accordion -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'accordion')]"
    mode="get-output-class"
  >
    <xsl:value-of select="BOOTSTRAP_CSS_ACCORDION"/>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes based on outputclass -->
  <xsl:template name="bootstrap-class">
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
        <xsl:text/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group')">
        <xsl:text/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-toolbar')">
        <xsl:text/>
      </xsl:when>
        <xsl:when test="contains(@outputclass, 'accordion-flush')">
        <xsl:text>accordion</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-')">
        <xsl:text>btn</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/ph ') and contains(@outputclass, 'bg-')">
        <xsl:text>badge</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'alert-')">
        <xsl:text>alert</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'carousel-')">
        <xsl:text>carousel</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/title ') and ancestor::*[contains(@outputclass, 'alert-')]">
        <xsl:text>alert-heading</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/xref ') and ancestor::*[contains(@outputclass, 'alert-')]">
        <xsl:text>alert-link</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/li ') and ancestor::ul[contains(@outputclass, 'list-group')]">
        <xsl:text>list-group-item</xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="@scalefit='yes'">
      <xsl:text> img-fluid</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <note> elements -->
  <xsl:template name="bootstrap-note">
    <xsl:text>alert </xsl:text>
    <xsl:choose>
      <xsl:when test="@type='tip'">
        <xsl:text>alert-success</xsl:text>
      </xsl:when>
      <xsl:when test="@type='fastpath'">
        <xsl:text>alert-success</xsl:text>
      </xsl:when>
      <xsl:when test="@type='remember'">
        <xsl:text>alert-success</xsl:text>
      </xsl:when>
      <xsl:when test="@type='restriction'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='important'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='attention'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='caution'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='warning'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='trouble'">
        <xsl:text>alert-warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type='danger'">
        <xsl:text>alert-danger</xsl:text>
      </xsl:when>
      <xsl:when test="@type='notice'">
        <xsl:text>alert-info</xsl:text>
      </xsl:when>
      <xsl:when test="@type='note'">
        <xsl:text>alert-info</xsl:text>
      </xsl:when>
      <xsl:when test="@type='other'">
        <xsl:text>alert-dark</xsl:text>
      </xsl:when>
      <xsl:otherwise>
         <xsl:text>alert-info</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add icons to <note> elements -->
  <xsl:template name="bootstrap-icon">
    <xsl:choose>
      <xsl:when test="@type='tip'">
        <i class="pe-2 bi bi-lightbulb"/>
      </xsl:when>
      <xsl:when test="@type='fastpath'">
        <i class="pe-2 bi bi-shield-check"/>
      </xsl:when>
      <xsl:when test="@type='remember'">
        <i class="pe-2 bi bi-clipboard-check"/>
      </xsl:when>
      <xsl:when test="@type='restriction'">
        <i class="pe-2 bi bi-slash-circle"/>
      </xsl:when>
      <xsl:when test="@type='important'">
        <i class="pe-2 bi bi-exclamation-circle-fill"/>
      </xsl:when>
      <xsl:when test="@type='attention'">
        <i class="pe-2 bi bi-exclamation-triangle"/>
      </xsl:when>
      <xsl:when test="@type='caution'">
        <i class="pe-2 bi bi-exclamation-triangle"/>
      </xsl:when>
      <xsl:when test="@type='warning'">
        <i class="pe-2 bi bi-exclamation-triangle"/>
      </xsl:when>
      <xsl:when test="@type='trouble'">
        <i class="pe-2 bi bi-exclamation-triangle"/>
      </xsl:when>
      <xsl:when test="@type='danger'">
        <i class="pe-2 bi bi-exclamation-triangle"/>
      </xsl:when>
      <xsl:when test="@type='notice'">
        <i class="pe-2 bi bi-info-circle-fill"/>
      </xsl:when>
      <!--xsl:when test="@type='note'"/-->
      <!--xsl:when test="@type='other'"/-->
    </xsl:choose>
  </xsl:template>

  <!-- add role attributes based on outputclass -->
  <xsl:template name="bootstrap-role">
    <xsl:choose>
       <xsl:when test="contains(@outputclass, 'alert-')">
          <xsl:attribute name="role" select="'alert'"/>
       </xsl:when>
       <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
          <xsl:attribute name="role" select="'group'"/>
       </xsl:when>
       <xsl:when test="contains(@outputclass, 'btn-group')">
          <xsl:attribute name="role" select="'group'"/>
       </xsl:when>
       <xsl:when test="contains(@outputclass, 'btn-toolbar')">
          <xsl:attribute name="role" select="'toolbar'"/>
       </xsl:when>
       <xsl:when test="contains(@outputclass, 'btn-')">
          <xsl:attribute name="role" select="'button'"/>
       </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
