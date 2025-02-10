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
  <xsl:param name="BOOTSTRAP_CSS_SHORTDESC" select="'text-body-secondary lead'"/>
  <xsl:param name="BOOTSTRAP_CSS_CODEBLOCK" select="'alert alert-secondary'"/>
  <xsl:param name="BOOTSTRAP_CSS_TOPIC_TITLE" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_SECTION_TITLE" select="'h4'"/>
  <xsl:param name="BOOTSTRAP_CSS_CARD" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_CAROUSEL" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_CAPTION" select="'alert alert-secondary p-1'"/>
  <xsl:param name="BOOTSTRAP_CSS_TABS" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABS_VERTICAL" select="'me-3'"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCORDION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCESSIBILITY_NAV" select="'bg-body-tertiary'"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCESSIBILITY_LINK" select="'btn btn-outline-primary btn-sm'"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE" select="' w-100 mw-100 p-3 '"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE_CAPTION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE_IMAGE" select="'img-fluid border rounded'"/>
  <xsl:param name="BOOTSTRAP_CSS_DL" select="'row'"/>
  <xsl:param name="BOOTSTRAP_CSS_DT" select="'text-truncate '"/>
  <xsl:param name="BOOTSTRAP_CSS_DD" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_PAGINATION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABLE" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABLE_HEAD" select="''"/>

  <xsl:param name="BOOTSTRAP_ICON_TIP" select="'bi bi-lightbulb'"/>
  <xsl:param name="BOOTSTRAP_ICON_FASTPATH" select="'bi bi-shield-check'"/>
  <xsl:param name="BOOTSTRAP_ICON_REMEMBER" select="'bi bi-clipboard-check'"/>
  <xsl:param name="BOOTSTRAP_ICON_RESTRICTION" select="'bi bi-slash-circle'"/>
  <xsl:param name="BOOTSTRAP_ICON_IMPORTANT" select="'bi bi-exclamation-circle-fill'"/>
  <xsl:param name="BOOTSTRAP_ICON_ATTENTION" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_CAUTION" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_WARNING" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_TROUBLE" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_DANGER" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_NOTICE" select="'bi bi-info-circle-fill'"/>
  <xsl:param name="BOOTSTRAP_ICON_NOTE" select="'bi bi-pencil'"/>

  <!-- Add a Bootstrap CSS border to codeblocks -->
  <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_CODEBLOCK"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Add a Bootstrap CSS border to tables -->
  <xsl:template match="*[contains(@class, ' topic/table ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_TABLE"/>

    <xsl:value-of
      select="
        if (@colsep='1' and @rowsep='1') then ' table-bordered'
        else if (@colsep='0' and @rowsep='0') then ' table-borderless'
        else ''"
    />
    <xsl:next-match/>
  </xsl:template>
  <!-- Enhance the default Bootstrap CSS text color of the table headers -->
  <xsl:template match="*[contains(@class, ' topic/thead ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_TABLE_HEAD"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Enhance the short desc with a Bootstrap CSS lead class -->
  <xsl:template match="*[contains(@class, ' topic/shortdesc ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_SHORTDESC"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS text color of the headers -->
  <xsl:template
    match="*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_TOPIC_TITLE"/>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
  >
    <xsl:value-of
      select="
        if (contains(@outputclass, 'h1')) then ''
        else if (contains(@outputclass, 'h2')) then ''
        else if (contains(@outputclass, 'h3')) then ''
        else if (contains(@outputclass, 'h4')) then ''
        else if (contains(@outputclass, 'h5')) then ''
        else if (contains(@outputclass, 'h6')) then ''
        else if (contains(@outputclass, 'display-')) then ''
        else ($BOOTSTRAP_CSS_SECTION_TITLE || ' ')"
    />
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of cards -->
  <xsl:template
    match="*[contains(@class,' topic/section ') and contains(@outputclass, 'card')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_CARD"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of carousel -->
  <xsl:template
    match="*[ (contains(@class,' topic/ul ') or contains(@class, ' topic/ol ')) and contains(@outputclass, 'carousel')]"
    mode="get-output-class"
  >
    <xsl:text>slide </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_CAROUSEL"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Amend the text and background of Figure Captions -->
  <xsl:template
    match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
    priority="5"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_CAPTION"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of tabs -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-tabs')]"
    mode="get-output-class"
  >
    <xsl:text>nav </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_TABS"/>
    <xsl:next-match/>
  </xsl:template>
  <!-- Change the default Bootstrap CSS classes of tab pills -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-pills')]"
    mode="get-output-class"
  >
    <xsl:text>nav </xsl:text>
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'nav-pills-vertical')">
        <xsl:text>flex-column nav-pills </xsl:text>
        <xsl:value-of select="$BOOTSTRAP_CSS_TABS_VERTICAL"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$BOOTSTRAP_CSS_TABS"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of accordion -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'accordion')]"
    mode="get-output-class"
  >
    <xsl:value-of select="BOOTSTRAP_CSS_ACCORDION"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS text color of the figure captions -->
  <xsl:template match="*[contains(@class, ' topic/figcaption ')]" mode="get-output-class">
    <xsl:text>figure-caption </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE_CAPTION"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of pagination -->
  <xsl:template
    match="*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul ')) and contains(@outputclass, 'pagination')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_PAGINATION"/>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class,' topic/section ') and contains(@outputclass, 'pagination')]/*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul '))]"
    mode="get-output-class"
  >
    <xsl:if test="ancestor::*[contains(@outputclass, 'pagination-')]">
      <xsl:text>pagination </xsl:text>
    </xsl:if>
    <xsl:value-of select="ancestor::*[contains(@outputclass, 'pagination')][1]/@outputclass"/>
    <xsl:value-of select="concat(' ', $BOOTSTRAP_CSS_PAGINATION)"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes based on outputclass -->
  <xsl:template name="bootstrap-class">
    <xsl:apply-templates select="." mode="bootstrap-class"/>
    <xsl:apply-templates select="." mode="gen-user-bootstrap-class"/>
  </xsl:template>
  <xsl:template match="/ | @* | node()" mode="gen-user-bootstrap-class"/>

  <xsl:template match="/ | @* | node()" mode="bootstrap-class">
    <xsl:choose>
      <xsl:when test="contains(@class, ' topic/dt ')">
        <xsl:if test="empty(@outputclass)">
          <xsl:call-template name="bootstrap-dt"/>
        </xsl:if>
        <xsl:value-of select="$BOOTSTRAP_CSS_DT"/>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/dd ')">
        <xsl:if test="empty(@outputclass)">
          <xsl:call-template name="bootstrap-dd"/>
        </xsl:if>
        <xsl:value-of select="$BOOTSTRAP_CSS_DD"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="
            if (contains(@outputclass, 'btn-group-vertical')) then ''
            else if (contains(@outputclass, 'btn-group')) then ''
            else if (contains(@outputclass, 'btn-toolbar')) then ''
            else if (contains(@outputclass, 'accordion-')) then 'accordion'
            else if (contains(@outputclass, 'btn-')) then 'btn'
            else if (contains(@outputclass, 'collapse-')) then 'collapse'
            else if (contains(@class, ' topic/ph ') and contains(@outputclass, 'bg-')) then 'badge'
            else if (contains(@outputclass, 'alert-')) then 'alert'
            else if (contains(@outputclass, 'list-group-')) then 'list-group'
            else if (contains(@class, ' topic/fig ')) then ' figure ' || $BOOTSTRAP_CSS_FIGURE
            else if (contains(@class, ' topic/lq ')) then ' blockquote '
            else if (contains(@class, ' topic/dl ')) then $BOOTSTRAP_CSS_DL
            else if (contains(@class, ' topic/image ') and ancestor::*[contains(@class, ' topic/fig ')]) then '  figure-img ' || $BOOTSTRAP_CSS_FIGURE_IMAGE
            else if (contains(@outputclass, 'carousel-')) then 'carousel'
            else if (contains(@class, ' topic/title ') and ancestor::*[contains(@outputclass, 'alert-')]) then 'alert-heading'
            else if (contains(@class, ' topic/xref ') and ancestor::*[contains(@outputclass, 'alert-')]) then 'alert-link'
            else if (contains(@class, ' topic/li ') and (ancestor::ul[contains(@outputclass, 'list-group')] or ancestor::ol[contains(@outputclass, 'list-group')])) then 'list-group-item'
            else if (contains(@class, ' topic/li ') and (ancestor::ul[contains(@outputclass, 'list-inline')] or ancestor::ol[contains(@outputclass, 'list-inline')])) then 'list-inline-item'
            else if (contains(@outputclass, 'pagination-')) then 'pagination'
            else if (contains(@class, ' topic/li ') and ancestor::*[contains(@outputclass, 'pagination')]) then 'page-item'
            else if (contains(@class, ' topic/xref ') and ancestor::*[contains(@outputclass, 'pagination')]) then 'page-link'
            else ''"
        />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="(@scalefit='yes')">
      <xsl:text> img-fluid</xsl:text>
    </xsl:if>
    <xsl:if test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
      <xsl:value-of
        select="
          if (contains(@class,' hi-d/i ') and contains(@outputclass, 'bi-')) then 'bi'
          else if (contains(@class, ' topic/xref ') and .//*[contains(@class,' hi-d/i ') and contains(@outputclass, 'bi-')]) then 'icon-link'
          else ''"
      />
    </xsl:if>
    <xsl:if test="ancestor::*[contains(@class, ' topic/dt ')]">
      <xsl:call-template name="bootstrap-dt-word-wrap"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <dd> elements -->
  <xsl:template name="bootstrap-dd">
    <xsl:variable name="terms" select="count(../*[contains(@class, ' topic/dt ')])"/>
    <xsl:variable name="is-first-dd" select="empty(preceding-sibling::*[contains(@class, ' topic/dd ')])"/>
    <xsl:choose>
      <xsl:when test="not($is-first-dd)">
        <xsl:text>col-lg-12 </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=1">
        <xsl:variable name="dl" select="../../."/>
        <xsl:value-of
          select="
            if (contains($dl/@otherprops, 'cols(6)')) then 'col-lg-6 '
            else if (contains($dl/@otherprops, 'cols(5)')) then 'col-lg-7 '
            else if (contains($dl/@otherprops, 'cols(4)')) then 'col-lg-8 '
            else if (contains($dl/@otherprops, 'cols(2)')) then 'col-lg-10 '
            else if (contains($dl/@otherprops, 'cols(1)')) then 'col-lg-11 '
            else 'col-lg-9 '"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="
            if ($terms=2) then 'col-lg-6 '
            else if ($terms=3) then 'col-lg-3 '
            else if ($terms=4) then 'col-lg-2 '
            else ''"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <dt> elements -->
  <xsl:template name="bootstrap-dt">
    <xsl:variable name="terms" select="count(../*[contains(@class, ' topic/dt ')])"/>
    <xsl:choose>
      <xsl:when test="$terms=1">
        <xsl:variable name="dl" select="../../."/>
        <xsl:value-of
          select="
            if (contains($dl/@otherprops, 'cols(6)')) then 'col-lg-6 '
            else if (contains($dl/@otherprops, 'cols(5)')) then 'col-lg-5 '
            else if (contains($dl/@otherprops, 'cols(4)')) then 'col-lg-4 '
            else if (contains($dl/@otherprops, 'cols(2)')) then 'col-lg-2 '
            else if (contains($dl/@otherprops, 'cols(1)')) then 'col-lg-1 '
            else 'col-lg-3 '"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="
            if ($terms=2) then 'col-lg-3 '
            else if ($terms=3) then 'col-lg-3 '
            else if ($terms=4) then 'col-lg-2 '
            else ''"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes to software elements -->
  <xsl:template name="bootstrap-dt-word-wrap">
    <xsl:value-of
      select="
        if (contains(@class,' pr-d/')) then ' text-wrap'
        else if (contains(@class,' sw-d/')) then ' text-wrap'
        else if (contains(@class,' xml-d/')) then ' text-wrap'
        else ''"
    />
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <note> elements -->
  <xsl:template name="bootstrap-note">
    <xsl:text>alert </xsl:text>
    <xsl:value-of
      select="
        if (@type='tip') then 'alert-success'
        else if (@type='fastpath') then 'alert-success'
        else if (@type='remember') then 'alert-success'
        else if (@type='restriction') then 'alert-warning'
        else if (@type='important') then 'alert-warning'
        else if (@type='attention') then 'alert-warning'
        else if (@type='caution') then 'alert-warning'
        else if (@type='warning') then 'alert-warning'
        else if (@type='trouble') then 'alert-warning'
        else if (@type='danger') then 'alert-danger'
        else if (@type='notice') then 'alert-info'
        else if (@type='note') then 'alert-primary'
        else if (@type='other') then 'alert-dark'
        else 'alert-info'"
    />
  </xsl:template>

  <!-- Add style to a bootstrap element based on otherprops -->
  <xsl:template name="otherprops-attributes">
    <xsl:apply-templates select="." mode="otherprops-attributes"/>
  </xsl:template>

  <xsl:template match="/ | @* | node()" mode="otherprops-attributes">
    <xsl:analyze-string select="@otherprops" regex="[A-Za-z0-9_\-]*\([^\)]*\)">
      <xsl:matching-substring>
        <xsl:variable name="var">
          <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="attr">
          <xsl:value-of select="substring-before($var, '(')"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$attr='icon'">
            <xsl:attribute name="class" select="concat('pe-2 ', substring-before(substring-after($var, '('),')'))"/>
          </xsl:when>
          <xsl:when test="$attr='media'">
            <xsl:attribute
              name="media"
              select="concat('(', concat( substring-before(substring-after($var, '('),')'), ')'))"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="{$attr}" select="substring-before(substring-after($var, '('),')')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <!-- Add icons to <note> elements -->
  <xsl:template name="bootstrap-icon">
    <xsl:variable name="icon">
      <xsl:value-of
        select="
          if (@type='tip') then $BOOTSTRAP_ICON_TIP
          else if (@type='fastpath') then $BOOTSTRAP_ICON_FASTPATH
          else if (@type='remember') then $BOOTSTRAP_ICON_REMEMBER
          else if (@type='restriction') then $BOOTSTRAP_ICON_RESTRICTION
          else if (@type='important') then $BOOTSTRAP_ICON_IMPORTANT
          else if (@type='attention') then $BOOTSTRAP_ICON_ATTENTION
          else if (@type='caution') then $BOOTSTRAP_ICON_CAUTION
          else if (@type='warning') then $BOOTSTRAP_ICON_WARNING
          else if (@type='trouble') then $BOOTSTRAP_ICON_TROUBLE
          else if (@type='danger') then $BOOTSTRAP_ICON_DANGER
          else if (@type='notice') then $BOOTSTRAP_ICON_NOTICE
          else if (@type='note') then $BOOTSTRAP_ICON_NOTE
          else ''"
      />
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="contains(@otherprops, 'icon(')">
        <xsl:element name="i">
          <xsl:call-template name="otherprops-attributes"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$icon != ''">
        <xsl:element name="i">
          <xsl:attribute name="class" select="concat('pe-2 ', $icon)"/>
          <xsl:if test="contains(@otherprops, 'style(')">
            <xsl:call-template name="otherprops-attributes"/>
          </xsl:if>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- add role attributes based on outputclass -->
  <xsl:template name="bootstrap-role">
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'alert-')">
        <xsl:attribute name="role" select="'alert'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
        <xsl:attribute name="role" select="'group'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group')">
        <xsl:attribute name="role" select="'group'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-toolbar')">
        <xsl:attribute name="role" select="'toolbar'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-')">
        <xsl:attribute name="role" select="'button'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
