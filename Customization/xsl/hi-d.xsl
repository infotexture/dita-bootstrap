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
  <xsl:template match="*[contains(@class,' hi-d/i ') and contains(@otherprops, 'style(')]" name="topic.hi-d.i">
    <em>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setidaname"/>
      <xsl:attribute name="style">
        <!--xsl:value-of select="replace(, ')', '')"/-->
        <xsl:analyze-string select="@otherprops" regex="[a-z]*\([^\)]*\)">
          <xsl:matching-substring>
            <xsl:variable name="var">
              <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:variable name="attr">
              <xsl:value-of select="substring-before($var, '(')"/>
            </xsl:variable>
            <xsl:attribute name="{$attr}">
              <xsl:value-of select="substring-before(substring-after($var, '('),')')"/>
            </xsl:attribute>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:attribute>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
</xsl:stylesheet>
