<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- <xsl:output omit-xml-declaration="yes" indent="yes"/>-->
    <xsl:output method="xml" indent="yes"/>
    <!-- <xsl:strip-space elements="*"/> -->
    <xsl:template match="text()"/>
    <xsl:template match="job/recipeSet/recipe[1]"><job><recipeSet><recipe><params><param>
<xsl:attribute name="name">LOOKASIDE</xsl:attribute>
<xsl:attribute name="value">http://<xsl:value-of select="$jumpHost"/>/lookaside/</xsl:attribute>
</param></params>
<xsl:apply-templates/></recipe></recipeSet></job>
</xsl:template>
<xsl:template match="task[fetch]">
    <xsl:variable name="repo_sub_path">
        <xsl:call-template name="getRepoSubPath">
            <xsl:with-param name="value" select="fetch/@url"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="repo_uri">
        <xsl:call-template name="getRepoURI">
            <xsl:with-param name="value" select="fetch/@url"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="schema">
        <xsl:call-template name="getRepoSchema">
            <xsl:with-param name="value" select="fetch/@url"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="repo_base_path">
        <xsl:call-template name="getRepoBasePath">
            <xsl:with-param name="value" select="$repo_uri"/>
            <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="dirname">
        <xsl:call-template name="getDirname">
            <xsl:with-param name="value" select="$repo_base_path"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="basename">
        <xsl:call-template name="getBasename">
            <xsl:with-param name="value" select="$repo_base_path"/>
        </xsl:call-template>
    </xsl:variable>
                <task>
                    <xsl:attribute name="name">
                        <xsl:value-of select="@name"/>
                    </xsl:attribute>
                    <xsl:copy-of select="params" />
                    <fetch>
			    <xsl:attribute name="url">http://<xsl:value-of select="$jumpHost"/>/tasks/<xsl:value-of select="$dirname"/><xsl:value-of select="$basename"/><xsl:choose><xsl:when test="$schema = 'git://'"><xsl:value-of select="'.tgz'"/></xsl:when></xsl:choose>#<xsl:value-of select="$repo_sub_path"/>
                        </xsl:attribute>
                    </fetch>
                </task>
</xsl:template>

  <xsl:template name="getRepoSubPath">
      <xsl:param name="value"/>
      <xsl:choose>
          <xsl:when test="not(string-length(translate($value, '#', ''))=string-length())">
              <xsl:value-of select="substring-after($value, '#')"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="''"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
  <xsl:template name="getRepoURI">
      <xsl:param name="value"/>
      <xsl:choose>
          <xsl:when test="string-length($value) != string-length(translate($value, '?', ''))">
              <xsl:value-of select="substring-before($value, '?')"/>
          </xsl:when>
          <xsl:when test="string-length($value) != string-length(translate($value, '#', ''))">
              <xsl:value-of select="substring-before($value, '#')"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="$value"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
  <xsl:template name="getRepoSchema">
    <xsl:param name="value"/>
    <xsl:value-of select="substring-before($value, '://')"/><xsl:value-of select="'://'"/>
  </xsl:template>
  <xsl:template name="getRepoBasePath">
      <xsl:param name="value"/>
      <xsl:param name="schema"/>
      <xsl:value-of select="substring-after($value, $schema)"/>
  </xsl:template>
  <xsl:template name="getDirname">
  <xsl:param name="value" />
  <xsl:param name="separator" select="'/'" />
  <xsl:choose>
      <xsl:when test="contains($value, $separator)">
        <xsl:value-of select="substring-before($value, $separator)"/><xsl:value-of select="'/'"/>
        <xsl:call-template name="getDirname">
          <xsl:with-param name="value" select="substring-after($value, $separator)" />
          <xsl:with-param name="separator" select="$separator" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="getBasename">
  <xsl:param name="value" />
  <xsl:param name="separator" select="'/'" />
  <xsl:choose>
      <xsl:when test="contains($value, $separator)">
      <xsl:call-template name="getBasename">
          <xsl:with-param name="value" select="substring-after($value, $separator)" />
          <xsl:with-param name="separator" select="$separator" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
