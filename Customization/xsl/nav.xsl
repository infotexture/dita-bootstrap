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
  <!-- https://getbootstrap.com/docs/5.0/components/list-group/ -->

  <xsl:param name="nav-toc" as="xs:string?"/>
  <xsl:param name="FILEDIR" as="xs:string?"/>
  <xsl:param name="FILENAME" as="xs:string?"/>
  <xsl:param name="input.map.url" as="xs:string?"/>

  <xsl:variable name="input.map" as="document-node()?">
    <xsl:apply-templates select="document($input.map.url)" mode="normalize-map"/>
  </xsl:variable>


  <!-- Override to add Bootstrap list-group classes -->
  <xsl:template match="*" mode="gen-user-sidetoc">
    <xsl:choose>
      <xsl:when test="$nav-toc = ('list-group-partial', 'list-group-full')">
        <nav xsl:use-attribute-sets="toc">
          <!-- ↓ Remove <ul> and add <div> element from Bootstrap list-group ↑ -->
          <div class="list-group me-3">
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
            <xsl:choose>
              <xsl:when test="$nav-toc = 'list-group-partial'">
                <xsl:apply-templates select="$current-topicref" mode="list-group-toc-pull">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                  <xsl:with-param name="children" as="element()*">
                      <xsl:apply-templates
                      select="$current-topicref/*[contains(@class, ' map/topicref ')]"
                      mode="list-group-toc"
                    >
                      <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:when test="$nav-toc = 'list-group-full'">
                <xsl:apply-templates select="$input.map" mode="list-group-toc">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                </xsl:apply-templates>
              </xsl:when>
            </xsl:choose>
          <!-- ↓ Close <div> element from Bootstrap list-group ↑ -->
          </div>
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        </nav>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="*[contains(@class, ' map/map ')]" mode="list-group-toc-pull">
    <xsl:param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
    <xsl:param name="children" select="()" as="element()*"/>
    <xsl:param name="parent" select="parent::*" as="element()?"/>
    <xsl:copy-of select="$children"/>
  </xsl:template>

  <xsl:template match="*" mode="list-group-toc-pull" priority="-10">
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param name="children" select="()" as="element()*"/>
    <xsl:param name="parent" select="parent::*" as="element()?"/>
    <xsl:apply-templates select="$parent" mode="list-group-toc-pull">
      <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      <xsl:with-param name="children" select="$children"/>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template match="*" mode="list-group-toc" priority="-10">
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="list-group-toc">
      <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
    </xsl:apply-templates>
  </xsl:template>


  <!-- Override to add Bootstrap list-group-item classes -->
  <xsl:template
    match="*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]"
    mode="list-group-toc-pull"
    priority="10"
  >
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param name="children" select="()" as="element()*"/>
    <xsl:param name="parent" select="parent::*" as="element()?"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>
    <xsl:apply-templates select="$parent" mode="list-group-toc-pull">
      <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      <xsl:with-param name="children" as="element()*">
        <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' map/topicref ')]" mode="list-group-toc">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
        <xsl:choose>
          <xsl:when test="normalize-space($title)">
              <xsl:choose>
                <xsl:when test="normalize-space(@href)">
                  <a>
                    <!-- ↓ Add Bootstrap list-group-item and action classes ↑ -->
                    <xsl:attribute name="class">
                      <xsl:text>list-group-item list-group-item-action</xsl:text>
                      <xsl:if test=". is $current-topicref">
                        <xsl:text> active</xsl:text>
                      </xsl:if>
                    </xsl:attribute>
                    <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
                    <xsl:attribute name="href">
                      <xsl:if test="not(@scope = 'external')">
                        <xsl:value-of select="$pathFromMaplist"/>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when
                        test="@copy-to and not(contains(@chunk, 'to-content')) and
                                        (not(@format) or @format = 'dita' or @format = 'ditamap') "
                      >
                          <xsl:call-template name="replace-extension">
                            <xsl:with-param name="filename" select="@copy-to"/>
                            <xsl:with-param name="extension" select="$OUTEXT"/>
                          </xsl:call-template>
                          <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                            <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                          </xsl:if>
                        </xsl:when>
                        <xsl:when
                        test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')"
                      >
                          <xsl:call-template name="replace-extension">
                            <xsl:with-param name="filename" select="@href"/>
                            <xsl:with-param name="extension" select="$OUTEXT"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="@href"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="$title"/>
                  </a>
                </xsl:when>
                <!--xsl:otherwise>
                  <xsl:value-of select="$title"/>
                </xsl:otherwise-->
              </xsl:choose>
              <xsl:if test="exists($children)">
                  <xsl:copy-of select="$children"/>
              </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="list-group-toc">
              <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="following-sibling::*[contains(@class, ' map/topicref ')]" mode="list-group-toc">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]"
    mode="list-group-toc"
    priority="10"
  >
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param
      name="children"
      select="if ($nav-toc = 'list-group-full') then *[contains(@class, ' map/topicref ')] else ()"
      as="element()*"
    />
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="normalize-space($title)">
          <xsl:choose>
            <xsl:when test="normalize-space(@href)">
              <a>
                <!-- ↓ Add Bootstrap list-group-item and action classes ↑ -->
                <xsl:attribute name="class">
                  <xsl:text>list-group-item list-group-item-action</xsl:text>
                  <xsl:if test="ancestor::*[contains(@class, ' map/topicref ')]/@href">
                    <xsl:text> list-group-item-secondary</xsl:text>
                  </xsl:if>
                  <xsl:if test=". is $current-topicref">
                    <xsl:text> active</xsl:text>
                  </xsl:if>
                </xsl:attribute>
                <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
                <xsl:attribute name="href">
                  <xsl:if test="not(@scope = 'external')">
                    <xsl:value-of select="$pathFromMaplist"/>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when
                    test="@copy-to and not(contains(@chunk, 'to-content')) and
                                    (not(@format) or @format = 'dita' or @format = 'ditamap') "
                  >
                      <xsl:call-template name="replace-extension">
                        <xsl:with-param name="filename" select="@copy-to"/>
                        <xsl:with-param name="extension" select="$OUTEXT"/>
                      </xsl:call-template>
                      <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                        <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:when
                    test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')"
                  >
                      <xsl:call-template name="replace-extension">
                        <xsl:with-param name="filename" select="@href"/>
                        <xsl:with-param name="extension" select="$OUTEXT"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@href"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="$title"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <!-- ↓ Add Bootstrap list-group-item class and dark color ↑ -->
              <span class="list-group-item list-group-item-dark">
                <xsl:value-of select="$title"/>
              </span>
              <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="exists($children)">
            <!--ul-->
              <xsl:apply-templates select="$children" mode="#current">
                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
              </xsl:apply-templates>
            <!--/ul-->
          </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
