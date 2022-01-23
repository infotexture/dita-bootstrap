<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  version="2.0"
  exclude-result-prefixes="xs xhtml dita-ot"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
  <!-- Customization to add Bootstrap Pagination Component -->
  <!-- https://getbootstrap.com/docs/5.1/components/pagination/ -->


  <xsl:param name="BOOTSTRAP_PAGINATION" select="'none'"/>
  <xsl:param name="BOOTSTRAP_PAGINATION_NEXT" select="''"/>
  <xsl:param name="BOOTSTRAP_PAGINATION_PREVIOUS" select="''"/>

  <!-- Add Bootstrap pagination -->
  <xsl:template
    match="*[ (contains(@class, ' topic/ol ') or contains(@class, ' topic/ul ')) and contains(@outputclass, 'pagination')]"
  >
    <nav>
      <xsl:next-match/>
    </nav>
  </xsl:template>

  <xsl:template
    match="*[ contains(@class, ' topic/section ') and contains(@outputclass, 'pagination')]"
  >
    <nav>
      <xsl:attribute name="aria-label">
        <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
      </xsl:attribute>
      <xsl:apply-templates select="*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul '))]" />
    </nav>
  </xsl:template>

  <!-- Add Footer pagination -->
  <xsl:template match="*" mode="gen-user-pagination">

    <xsl:variable name="hasSiblings" select="count(../*[contains(@class, ' map/topicref ')]) gt 1"/>
    <xsl:variable name="currentTopic" select="count(preceding-sibling::*[contains(@class, ' map/topicref ')]) + 1"/>
    <xsl:variable name="hasPrevious" select="$currentTopic gt 1"/>
    <xsl:variable name="hasNext" select="count(following-sibling::*[contains(@class, ' map/topicref ')]) gt 0"/>


    <xsl:if test="$hasSiblings">
      <nav role="navigation">
        <xsl:attribute name="aria-label">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Contents'"/>
          </xsl:call-template>
        </xsl:attribute>
        <ol>
          <xsl:attribute name="class">
            <xsl:text>pagination mt-4 </xsl:text>
            <xsl:value-of select="$BOOTSTRAP_CSS_PAGINATION"/>
          </xsl:attribute>

          <xsl:call-template name="pagination-previous">
            <xsl:with-param name="hasPrevious" select="$hasPrevious" />
            <xsl:with-param name="currentTopic" select="$currentTopic"/>
          </xsl:call-template>

          <xsl:if test="$BOOTSTRAP_PAGINATION = 'full'">
            <xsl:for-each select="../*[contains(@class, ' map/topicref ')]">
              <xsl:variable name="title">
                <xsl:apply-templates select="." mode="get-navtitle"/>
              </xsl:variable>
              <li class="page-item">
                <xsl:attribute name="class">
                  <xsl:text>page-item</xsl:text>
                  <xsl:if test="position() eq $currentTopic">
                    <xsl:text> active</xsl:text>
                  </xsl:if>
                </xsl:attribute>
                <xsl:if test="position() eq $currentTopic">
                  <xsl:attribute name="aria-current" select="'page'"/>
                </xsl:if>
                <a>
                  <xsl:attribute name="aria-label">
                    <xsl:value-of select="$title"/>
                  </xsl:attribute>
                  <xsl:call-template name="nav-attributes">
                    <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                    <xsl:with-param name="class" select="'page-link'"/>
                  </xsl:call-template>
                  <xsl:value-of select="position()" />
                </a>
              </li>
            </xsl:for-each>
          </xsl:if>

          <xsl:call-template name="pagination-next">
            <xsl:with-param name="hasNext" select="$hasNext" />
            <xsl:with-param name="currentTopic" select="$currentTopic"/>
          </xsl:call-template>
        </ol>
      </nav>
    </xsl:if>
  </xsl:template>

  <!-- Add bootstrap classes and href to a link taking in an aribitrary node -->
  <xsl:template match="*" mode="nav-attributes">
    <xsl:call-template name="nav-attributes">
      <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
      <xsl:with-param name="class" select="'page-link'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Add bootstrap classes and href to a link  for the current node -->
  <xsl:template name="nav-attributes">
    <xsl:param name="class" as="xs:string"/>
    <xsl:param name="pathFromMaplist" as="xs:string"/>

    <xsl:attribute name="class">
      <xsl:value-of select="$class"/>
    </xsl:attribute>
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
          <xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
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
  </xsl:template>

  <!-- Add the Previous topic link to the pagination bar -->
  <xsl:template name="pagination-previous">
    <xsl:param name="hasPrevious" as="xs:boolean"/>
    <xsl:param name="currentTopic" as="xs:integer"/>
    <li>
      <xsl:attribute name="class">
        <xsl:text>page-item</xsl:text>
        <xsl:if test="not($hasPrevious)">
          <xsl:text> disabled</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$hasPrevious">
          <a>
            <xsl:attribute name="aria-label">
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Previous topic'"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates mode="nav-attributes" select="../*[contains(@class, ' map/topicref ')][$currentTopic - 1]"/>
            <xsl:choose>
              <xsl:when test="$BOOTSTRAP_PAGINATION_PREVIOUS = ''">
                <xsl:call-template name="getVariable">
                  <xsl:with-param name="id" select="'Previous'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <span aria-hidden="true">
                  <xsl:value-of select="$BOOTSTRAP_PAGINATION_PREVIOUS"/>
                </span>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <span class="page-link" aria-hidden="true">
            <xsl:choose>
              <xsl:when test="$BOOTSTRAP_PAGINATION_PREVIOUS = ''">
                <xsl:call-template name="getVariable">
                  <xsl:with-param name="id" select="'Previous'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$BOOTSTRAP_PAGINATION_PREVIOUS"/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <!-- Add the Next topic link to the pagination bar -->
  <xsl:template name="pagination-next">
    <xsl:param name="hasNext" as="xs:boolean"/>
    <xsl:param name="currentTopic" as="xs:integer"/>
    <li>
      <xsl:attribute name="class">
        <xsl:text>page-item</xsl:text>
        <xsl:if test="not($hasNext)">
          <xsl:text> disabled</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$hasNext">
          <a>
            <xsl:attribute name="aria-label">
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Next topic'"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates mode="nav-attributes" select="../*[contains(@class, ' map/topicref ')][$currentTopic + 1]"/>

            <xsl:choose>
              <xsl:when test="$BOOTSTRAP_PAGINATION_NEXT = ''">
                <xsl:call-template name="getVariable">
                  <xsl:with-param name="id" select="'Next'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <span aria-hidden="true">
                  <xsl:value-of select="$BOOTSTRAP_PAGINATION_NEXT"/>
                </span>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <span class="page-link" aria-hidden="true">
            <xsl:choose>
              <xsl:when test="$BOOTSTRAP_PAGINATION_NEXT = ''">
                  <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Next'"/>
                  </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:value-of select="$BOOTSTRAP_PAGINATION_NEXT"/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>
</xsl:stylesheet>
