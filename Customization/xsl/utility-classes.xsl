<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xs dita-ot">

  <!-- Add a border to codeblocks -->
  <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="get-output-class">border rounded</xsl:template>

  <!-- Enhance the short desc with a lead class -->
  <xsl:template match="*[contains(@class, ' topic/shortdesc ')]" mode="get-output-class">text-muted lead</xsl:template>

  <!-- Change the text color of the headers -->
  <xsl:template match="*[contains(@class, ' topic/title ')]" mode="get-output-class">text-dark</xsl:template>

  <!-- Amend the text and background of Figure Captions -->
  <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]" mode="get-output-class" priority="5">text-white bg-dark</xsl:template>


</xsl:stylesheet>
