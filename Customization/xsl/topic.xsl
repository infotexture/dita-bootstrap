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


  <!-- Override to add Bootstrap classes and roles -->
  <xsl:template name="commonattributes">
    <xsl:param name="default-output-class"/>
    <!-- ↓ Add Bootstrap class attributes template ↑ -->
    <xsl:variable name="bootstrap-class">
       <xsl:call-template name="bootstrap-class"/>
       <xsl:value-of select="$default-output-class"/>
    </xsl:variable>
    <xsl:call-template name="bootstrap-role"/>
    <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
    <xsl:apply-templates select="@xml:lang"/>
    <xsl:apply-templates select="@dir"/>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style" mode="add-ditaval-style"/>
    <xsl:choose>
      <!-- ↓ Remove DITA-OT styling from titles since Bootstrap does this ↑ -->
      <xsl:when test="starts-with($default-output-class , 'topictitle')">
        <xsl:apply-templates select="." mode="set-output-class">
         <xsl:with-param name="default" select="replace($bootstrap-class, 'topictitle\d+', '')"/>
        </xsl:apply-templates>
      </xsl:when>
       <xsl:when test="starts-with($default-output-class , 'sectiontitle')">
        <xsl:apply-templates select="." mode="set-output-class">
         <xsl:with-param name="default" select="replace($bootstrap-class, 'sectiontitle', '')"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="set-output-class">
         <xsl:with-param name="default" select="$bootstrap-class"/>
      </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
    <xsl:choose>
       <xsl:when test="exists($passthrough-attrs[empty(@att) and empty(@value)])">
          <xsl:variable name="specializations" as="xs:string*">
             <xsl:for-each select="ancestor-or-self::*[@domains][1]/@domains">
                <xsl:analyze-string select="normalize-space(.)" regex="a\(props (.+?)\)">
                   <xsl:matching-substring>
                      <xsl:sequence select="tokenize(regex-group(1), '\s+')"/>
                   </xsl:matching-substring>
                </xsl:analyze-string>
             </xsl:for-each>
          </xsl:variable>
          <xsl:for-each
          select="@props |  @audience | @platform | @product | @otherprops | @deliveryTarget |  @*[local-name() = $specializations]"
        >
             <xsl:attribute name="data-{name()}" select="."/>
          </xsl:for-each>
       </xsl:when>
       <xsl:when test="exists($passthrough-attrs)">
          <xsl:for-each select="@*">
             <xsl:if
            test="$passthrough-attrs[@att = name(current()) and (empty(@val) or (some $v in tokenize(current(), '\s+') satisfies $v = @val))]"
          >
                <xsl:attribute name="data-{name()}" select="."/>
             </xsl:if>
          </xsl:for-each>
       </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Override  Notes to add Bootstrap classes and roles -->
  <xsl:template match="*" mode="process.note.common-processing">
    <xsl:param name="type" select="@type"/>
    <xsl:param name="title">
      <xsl:call-template name="getVariable">
        <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
      </xsl:call-template>
    </xsl:param>
    <!-- ↓ Add Bootstrap class attributes template ↑ -->
    <xsl:variable name="bootstrap-class">
        <xsl:if test="not(contains(@outputclass, 'alert-'))">
          <xsl:call-template name="bootstrap-note"/>
        </xsl:if>
    </xsl:variable>
    <div role="alert">
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$bootstrap-class"/>
        <!--xsl:with-param name="default-output-class" select="string-join(($type, concat('note_', $type)), ' ')"/-->
      </xsl:call-template>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="setidaname"/>
      <!-- Normal flags go before the generated title; revision flags only go on the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
      <span class="note__title">
        <!-- ↓ Add Bootstrap icon ↑ -->
        <xsl:if test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
          <xsl:call-template name="bootstrap-icon"/>
        </xsl:if>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:copy-of select="$title"/>
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="'ColonSymbol'"/>
        </xsl:call-template>
      </span>
      <xsl:text> </xsl:text>
      <xsl:apply-templates
        select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
        mode="ditaval-outputflag"
      />
      <xsl:apply-templates/>
      <!-- Normal end flags and revision end flags both go out after the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
