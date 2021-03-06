<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xs dita-ot">

   <!-- add role attributes based on outputclass -->
   <xsl:template name="bootstrap-role">
      <xsl:choose>
         <xsl:when test="contains(@outputclass, 'alert-')">
            <xsl:attribute name="role" select="'alert'" />
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
            <xsl:attribute name="role" select="'group'" />
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-group')">
            <xsl:attribute name="role" select="'group'" />
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-toolbar')">
            <xsl:attribute name="role" select="'toolbar'" />
         </xsl:when>
         <xsl:when test="contains(@outputclass, 'btn-')">
            <xsl:attribute name="role" select="'button'" />
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!-- add additional bootstrap classes based on outputclass -->
   <xsl:template name="bootstrap-class">
      <xsl:choose>
         <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
            <xsl:text />
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

      <!-- Override to add Bootstrap classes and roles to <note> elements -->
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
</xsl:stylesheet>
