<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA-OT Bootstrap Components Plug-in project.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xs xhtml dita-ot">
   <xsl:template match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-tabs')]">

		<ul role="tablist">
			<xsl:call-template name="commonattributes">
				<xsl:with-param name="default-output-class" select="'nav'" />
			</xsl:call-template>
			<xsl:call-template name="setid"/>
			<xsl:apply-templates mode="nav-tabs" select="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]"/>
		</ul>
	</xsl:template>



	<xsl:template match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-pills')]">

		<ul role="tablist">
			<xsl:call-template name="commonattributes">
				<xsl:with-param name="default-output-class" select="'nav'" />
			</xsl:call-template>
			<xsl:call-template name="setid"/>
			<xsl:apply-templates mode="nav-pills" select="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]"/>
		</ul>
	</xsl:template>



	<xsl:template match="*[contains(@class,' topic/title ')]" mode="nav-tabs">
		<li class="nav-item" role="presentation">
	    	<button class="nav-link active" id="home-tab" data-bs-toggle="tab" data-bs-target="#home" type="button" role="tab" aria-controls="home" aria-selected="true">
	    		<xsl:value-of select="."/>

	    	</button>
	  </li>
	</xsl:template>

	<xsl:template match="*[contains(@class,' topic/title ')]" mode="nav-pills">
	</xsl:template>
</xsl:stylesheet>