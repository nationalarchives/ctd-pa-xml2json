<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" encoding="utf-8"/>
    <xsl:strip-space elements="*"/>

    
    <xsl:template match="DScribeDatabase/DScribeRecord">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="PhysicalDescription">
        <xsl:value-of select="text()"/><xsl:text>
</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>