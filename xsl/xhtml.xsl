<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA-OT Bootstrap Components Plug-in project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xs dita-ot">
   

   <xsl:include href="../Customization/xsl/accordion.xsl" />
   <xsl:include href="../Customization/xsl/card.xsl" />
   <xsl:include href="../Customization/xsl/carousel.xsl" />
   <xsl:include href="../Customization/xsl/tabs.xsl" />


   <xsl:template name="bootstrap-role">
      <xsl:choose>
         <xsl:when test="contains(@outputclass, 'alert-')">
            <xsl:attribute name="role" select="'alert'" />
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-group')">
            <xsl:attribute name="role" select="'group'" />
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-toolbar')">
            <xsl:attribute name="role" select="'toolbar'" />
         </xsl:when>
      </xsl:choose>
   </xsl:template>


   <xsl:template name="bootstrap-class">
      <xsl:choose>
         <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
            <xsl:text>btn-group</xsl:text>
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-group')">
            <xsl:text />
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-toolbar')">
            <xsl:text />
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-')">
            <xsl:text>btn</xsl:text>
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'bg-')">
            <xsl:text>badge</xsl:text>
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'alert-')">
            <xsl:text>alert</xsl:text>
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
         <!--xsl:when test="contains(@class, ' topic/li ') and ancestor::ul[contains(@outputclass, 'nav')]">
            <xsl:text>nav-item</xsl:text>
         </xsl:when>
         <xsl:when test="contains(@class, ' topic/xref ') and ancestor::ul[contains(@outputclass, 'nav')]">
            <xsl:text>nav-link</xsl:text>
         </xsl:when-->
      </xsl:choose>
   </xsl:template>



   <xsl:template name="commonattributes">
      <xsl:param name="default-output-class" />
      <xsl:variable name="bootstrap-class">
         <xsl:call-template name="bootstrap-class" />
         <xsl:value-of select="$default-output-class" />
      </xsl:variable>
      <xsl:call-template name="bootstrap-role" />
      <xsl:apply-templates select="@xml:lang" />
      <xsl:apply-templates select="@dir" />
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style" mode="add-ditaval-style" />
      <xsl:apply-templates select="." mode="set-output-class">
         <xsl:with-param name="default" select="$bootstrap-class" />
      </xsl:apply-templates>
      <xsl:choose>
         <xsl:when test="exists($passthrough-attrs[empty(@att) and empty(@value)])">
            <xsl:variable name="specializations" as="xs:string*">
               <xsl:for-each select="ancestor-or-self::*[@domains][1]/@domains">
                  <xsl:analyze-string select="normalize-space(.)" regex="a\(props (.+?)\)">
                     <xsl:matching-substring>
                        <xsl:sequence select="tokenize(regex-group(1), '\s+')" />
                     </xsl:matching-substring>
                  </xsl:analyze-string>
               </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="@props |  @audience | @platform | @product | @otherprops | @deliveryTarget |  @*[local-name() = $specializations]">
               <xsl:attribute name="data-{name()}" select="." />
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="exists($passthrough-attrs)">
            <xsl:for-each select="@*">
               <xsl:if test="$passthrough-attrs[@att = name(current()) and (empty(@val) or (some $v in tokenize(current(), '\s+') satisfies $v = @val))]">
                  <xsl:attribute name="data-{name()}" select="." />
               </xsl:if>
            </xsl:for-each>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>