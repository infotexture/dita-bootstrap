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

  <xsl:param name="nav-toc" as="xs:string?"/>
  <xsl:param name="FILEDIR" as="xs:string?"/>
  <xsl:param name="FILENAME" as="xs:string?"/>
  <xsl:param name="input.map.url" as="xs:string?"/>

  <xsl:variable name="input.map" as="document-node()?">
    <xsl:apply-templates select="document($input.map.url)" mode="normalize-map"/>
  </xsl:variable>

  <!-- A topic is active if it is currently selected -->
  <xsl:template name="get-active-class">
    <xsl:choose>
      <xsl:when test=". is $current-topicref">
        <xsl:value-of select="' active'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="descendant::*">
          <xsl:if test=". is $current-topicref">
            <xsl:value-of select="' active'"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add bootstrap classes and href to a link -->
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

  <!-- Generate a menubar-toc - a menubar as part of the static header -->
  <xsl:template match="*" mode="gen-user-toptoc">
    <div class="container">
      <nav xsl:use-attribute-sets="menubar-toc">
        <ul class="nav nav-pills" role="menubar">
          <xsl:apply-templates select="$input.map" mode="menubar-toc">
            <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
          </xsl:apply-templates>
        </ul>
      </nav>
    </div>
  </xsl:template>

  <!-- Override to add Bootstrap list-group and nav-pill classes -->
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
      <xsl:when test="$nav-toc = ('list-group-scrollspy')">
        <nav xsl:use-attribute-sets="toc">
          <div class="list-group me-3" id="bs-scrollspy">
            <xsl:apply-templates mode="scrollspy"/>
          </div>
        </nav>
      </xsl:when>

      <xsl:when test="$nav-toc = ('nav-pill-partial', 'nav-pill-full')">
        <nav xsl:use-attribute-sets="toc">
          <!-- ↓ Remove <ul> and add <div> element from Bootstrap list-group ↑ -->
          <nav class="nav nav-pills flex-column navbar-light bg-light">
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
            <xsl:choose>
              <xsl:when test="$nav-toc = 'nav-pill-partial'">
                <xsl:apply-templates select="$current-topicref" mode="nav-pill-toc-pull">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                  <xsl:with-param name="children" as="element()*">
                      <xsl:apply-templates
                      select="$current-topicref/*[contains(@class, ' map/topicref ')]"
                      mode="nav-pill-toc"
                    >
                      <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:when test="$nav-toc = 'nav-pill-full'">
                <xsl:apply-templates select="$input.map" mode="nav-pill-toc">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                </xsl:apply-templates>
              </xsl:when>
            </xsl:choose>
          <!-- ↓ Close <div> element from Bootstrap list-group ↑ -->
          </nav>
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        </nav>
      </xsl:when>
      <xsl:when test="$nav-toc = ('nav-pill-scrollspy')">
        <nav xsl:use-attribute-sets="toc">
          <!-- ↓ Remove <ul> and add <div> element from Bootstrap list-group ↑ -->
          <nav class="nav nav-pills flex-column navbar-light bg-light" id="bs-scrollspy">
            <xsl:apply-templates mode="scrollspy"/>
          </nav>
        </nav>
      </xsl:when>

      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- list-group sidebar toc processing to add Bootstrap list-group menu -->
  <!-- https://getbootstrap.com/docs/5.1/components/list-group/ -->
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

  <!-- nav-pill sidebar toc processing to add Bootstrap nav-pills menu -->
  <!-- https://getbootstrap.com/docs/5.1/components/navs-tabs/ -->
  <xsl:template match="*[contains(@class, ' map/map ')]" mode="nav-pill-toc-pull">
    <xsl:param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
    <xsl:param name="children" select="()" as="element()*"/>
    <xsl:param name="parent" select="parent::*" as="element()?"/>
    <xsl:copy-of select="$children"/>
  </xsl:template>

  <xsl:template match="*" mode="nav-pill-toc-pull" priority="-10">
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param name="children" select="()" as="element()*"/>
    <xsl:param name="parent" select="parent::*" as="element()?"/>
    <xsl:apply-templates select="$parent" mode="nav-pill-toc-pull">
      <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      <xsl:with-param name="children" select="$children"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="nav-pill-toc" priority="-10">
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="nav-pill-toc">
      <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- nav-pill menubar-toc submenu toc processing - a navbar with dropdowns -->
  <!-- https://getbootstrap.com/docs/5.1/components/dropdowns/ -->
  <xsl:template match="*[contains(@class, ' map/map ')]" mode="menubar-toc-pull">
    <xsl:param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
    <xsl:param name="children" select="()" as="element()*"/>
    <xsl:param name="parent" select="parent::*" as="element()?"/>
    <xsl:copy-of select="$children"/>
  </xsl:template>

  <xsl:template match="*" mode="menubar-toc-pull" priority="-10">
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param name="children" select="()" as="element()*"/>
    <xsl:param name="parent" select="parent::*" as="element()?"/>
    <xsl:apply-templates select="$parent" mode="menubar-toc-pull">
      <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      <xsl:with-param name="children" select="$children"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="menubar-toc" priority="-10">
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="menubar-toc">
      <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- list-group-toc-pull mode to add Bootstrap list-group-item classes to a sidebar -->
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
                  <!-- ↓ Add Bootstrap list-group-item and action classes -->
                  <xsl:call-template name="nav-attributes">
                    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                    <xsl:with-param name="class">
                      <xsl:text>list-group-item list-group-item-action</xsl:text>
                      <xsl:if test=". is $current-topicref">
                        <xsl:text> active</xsl:text>
                      </xsl:if>
                    </xsl:with-param>
                  </xsl:call-template>
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

  <!-- list-group-toc mode to add Bootstrap list-group-item classes to a sidebar -->
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

    <xsl:variable name="active-class">
      <xsl:call-template name="get-active-class"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$BOOTSTRAP_MENUBAR_TOC = 'yes' and count(ancestor::*/@href) eq 0 and not($active-class = ' active')">
        <!-- no-op - if a menubar-toc is present, the list-group is reduced to current decendents only -->
      </xsl:when>
      <xsl:when test="normalize-space($title)">
        <xsl:choose>
          <xsl:when test="normalize-space(@href)">
            <a>
              <!-- ↓ Add Bootstrap list-group-item and action classes ↓ -->
              <xsl:call-template name="nav-attributes">
                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                <xsl:with-param name="class">
                  <xsl:text>list-group-item list-group-item-action</xsl:text>
                  <xsl:if test="parent::* is $current-topicref">
                    <xsl:text> bg-light</xsl:text>
                  </xsl:if>
                  <xsl:if test=". is $current-topicref">
                    <xsl:text> active</xsl:text>
                  </xsl:if>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:value-of select="$title"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <!-- ↓ Add Bootstrap list-group-item class and light background color ↓ -->
            <span class="list-group-item bg-light">
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


  <!-- nav-pill-toc-pull mode to add Bootstrap nav-link classes to a sidebar -->
  <xsl:template
    match="*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]"
    mode="nav-pill-toc-pull"
    priority="10"
  >
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param name="children" select="()" as="element()*"/>
    <xsl:param name="parent" select="parent::*" as="element()?"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>

    <xsl:variable name="active-class">
      <xsl:call-template name="get-active-class"/>
    </xsl:variable>

    <xsl:apply-templates select="$parent" mode="nav-pill-toc-pull">
      <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
      <xsl:with-param name="children" as="element()*">
        <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' map/topicref ')]" mode="nav-pill-toc">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
        <xsl:choose>
          <xsl:when test="normalize-space($title)">
            <xsl:choose>
              <xsl:when test="normalize-space(@href)">
                <a>
                  <!-- ↓ Add Bootstrap nav-link and action classes -->
                  <xsl:call-template name="nav-attributes">
                    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                    <xsl:with-param name="class">
                      <xsl:text>my-1 nav-link</xsl:text>
                       <xsl:value-of select="$active-class"/>
                    </xsl:with-param>
                  </xsl:call-template>
                  <xsl:value-of select="$title"/>
                </a>
              </xsl:when>
              <!--xsl:otherwise>
                  <xsl:value-of select="$title"/>
                </xsl:otherwise-->
            </xsl:choose>
            <xsl:if test="exists($children)">
              <nav class="nav nav-pills flex-column ps-3">
                <xsl:copy-of select="$children"/>
              </nav>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="nav-pill-toc">
              <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="following-sibling::*[contains(@class, ' map/topicref ')]" mode="nav-pill-toc">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!-- nav-pill-toc mode to add Bootstrap nav-link classes to a sidebar -->
  <xsl:template
    match="*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]"
    mode="nav-pill-toc"
    priority="10"
  >
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param
      name="children"
      select="if ($nav-toc = 'nav-pill-full') then *[contains(@class, ' map/topicref ')] else ()"
      as="element()*"
    />
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>

    <xsl:variable name="active-class">
      <xsl:call-template name="get-active-class"/>
    </xsl:variable>


    <xsl:choose>
      <xsl:when test="$BOOTSTRAP_MENUBAR_TOC = 'yes' and count(ancestor::*/@href) eq 0 and not($active-class = ' active')">
        <!-- no-op - if a menubar-toc is present, the nav-bar is reduced to current decendents only -->
      </xsl:when>
      <xsl:when test="normalize-space($title)">
        <xsl:choose>
          <xsl:when test="normalize-space(@href)">
            <a>
              <!-- ↓ Add Bootstrap nav-link and action classes ↓ -->
              <xsl:call-template name="nav-attributes">
                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                <xsl:with-param name="class">
                  <xsl:text>my-1 nav-link</xsl:text>
                  <xsl:value-of select="$active-class"/>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:value-of select="$title"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <!-- ↓ Add Bootstrap nav-brand class ↓ -->
            <span class="my-1 ps-3 navbar-brand">
              <xsl:value-of select="$title"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="exists($children)">
          <nav class="nav nav-pills flex-column ps-3">
            <xsl:apply-templates select="$children" mode="#current">
              <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            </xsl:apply-templates>
          </nav>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- menubar-toc mode to add Bootstrap nav-link classes to a menubar-toc - a submenu as part of the header -->
  <xsl:template
    match="*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]"
    mode="menubar-toc"
    priority="10"
  >
    <xsl:param name="pathFromMaplist" as="xs:string"/>
    <xsl:param name="children" select="*[contains(@class, ' map/topicref ')]"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="normalize-space($title)">
        <xsl:choose>
          <xsl:when test="normalize-space(@href)">
            <li class="nav-item" role="none">
              <a role="menuitem">
                <!-- ↓ Add Bootstrap nav-link classes -->
                <xsl:call-template name="nav-attributes">
                  <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                  <xsl:with-param name="class" select="'nav-link'"/>
                </xsl:call-template>
                <xsl:value-of select="$title"/>
              </a>
            </li>
          </xsl:when>
          <xsl:otherwise>
            <!-- ↓ Add Bootstrap nav-item class and dropdown ↓ -->
            <li class="nav-item dropdown" role="none">
              <a
                class="nav-link dropdown-toggle"
                data-bs-toggle="dropdown"
                href="#"
                role="menuitem"
                aria-expanded="false"
                aria-haspopup="true"
              >
                <xsl:value-of select="$title"/>
              </a>
              <ul class="dropdown-menu" role="menu">
                <!-- menubar-toc dropdown menu items must be active links -->
                <xsl:for-each select="$children">
                  <xsl:variable name="title">
                    <xsl:apply-templates select="." mode="get-navtitle"/>
                  </xsl:variable>
                  <li role="none">
                    <a role="menuitem">
                      <xsl:call-template name="nav-attributes">
                        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                        <xsl:with-param name="class" select="'dropdown-item'"/>
                      </xsl:call-template>
                      <xsl:value-of select="$title"/>
                    </a>
                  </li>
                </xsl:for-each>
              </ul>
            </li>
            <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
