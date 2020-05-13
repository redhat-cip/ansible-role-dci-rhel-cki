<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <xsl:output method="text" media-type="text/yml"/>
    <!-- <xsl:strip-space elements="*"/> -->
    <xsl:template match="text()"/>
    <xsl:template match="job/recipeSet/recipe[1]">---
<xsl:apply-templates/>
</xsl:template>
<xsl:template match="task[fetch]">
    <xsl:variable name="repo_branch">
        <xsl:call-template name="getRepoBranch">
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
    </xsl:variable>- name: Create task directory if it does not exist
  delegate_to: localhost
  file:
    path: "{{ local_repo }}/tasks/<xsl:value-of select="$dirname"/>"
    state: directory
    mode: '0755'
<xsl:choose>
    <xsl:when test="$schema = 'git://'">- name: Get Task <xsl:value-of select="fetch/@url"/>
  delegate_to: localhost
  git:
    repo: <xsl:value-of select="$repo_uri"/>
    dest: ./git_repos/<xsl:value-of select="$repo_base_path"/>
    version: <xsl:value-of select="$repo_branch"/>
    depth: 1
  run_once: True
- name: Archive Task
  delegate_to: localhost
  archive:
    path: ./git_repos/<xsl:value-of select="$repo_base_path"/>/
    dest: "{{ local_repo }}/tasks/<xsl:value-of select="$dirname"/><xsl:value-of select="$basename"/>.tgz"

</xsl:when>
        <xsl:otherwise>- name: Download Task
  delegate_to: localhost
  get_url:
    url: <xsl:value-of select="$repo_uri"/>
    dest: "{{ local_repo }}/tasks/<xsl:value-of select="$dirname"/><xsl:value-of select="$basename"/>"
    mode: 0755

</xsl:otherwise>
    </xsl:choose>

</xsl:template>
  <xsl:template name="getRepoBranch">
      <xsl:param name="value"/>
      <xsl:choose>
          <xsl:when test="string-length($value) != string-length(translate($value,'?',''))">
              <xsl:variable name="branch_path" select="substring-after($value, '?')"/>
              <xsl:choose>
                  <xsl:when test="string-length($branch_path) != string-length(translate($branch_path, '#', ''))">
                      <xsl:value-of select="substring-before($branch_path, '#')"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:value-of select="$branch_path"/>
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="'HEAD'"/>
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
