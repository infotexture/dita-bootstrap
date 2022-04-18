<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:table="http://dita-ot.sourceforge.net/ns/201007/dita-ot/table"
  version="2.0"
  exclude-result-prefixes="xs dita-ot table"
>
  <!--override row processing -->
  <xsl:template match="*[contains(@class, ' topic/row ')]" name="topic.row">
    <tr>
      <xsl:attribute name="class" select="@outputclass"/>
      <xsl:apply-templates select="@xml:lang"/>
      <xsl:apply-templates select="@dir"/>
      <xsl:apply-templates
        select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style"
        mode="add-ditaval-style"
      />
      <xsl:call-template name="setid"/>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>


  <xsl:template match="*[contains(@class, ' topic/table ')]" mode="css-class">
    <xsl:apply-templates select="@pgwide, @scale" mode="#current"/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/table ')]" name="topic.table">
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>

    <table>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setid"/>
      <xsl:apply-templates select="." mode="css-class"/>
      <xsl:apply-templates select="." mode="table:title"/>
      <!-- title and desc are processed elsewhere -->
      <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
    </table>

    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  </xsl:template>

</xsl:stylesheet>
