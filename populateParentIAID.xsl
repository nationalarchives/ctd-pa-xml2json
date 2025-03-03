<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/> 
    
    <xsl:template match="xml">
        <xml>
            <xsl:apply-templates select="record" />  
        </xml>
    </xsl:template>
    
    <xsl:template match="record">
        <xsl:variable name="parent-ref"><xsl:value-of select="substring(replace(current()/@refno, '(.*/).+', '$1'), 1, string-length(replace(current()/@refno, '(.*/).+', '$1')) - 1)"/></xsl:variable>
        <record>
            <xsl:attribute name="refno"><xsl:value-of select="@refno"/></xsl:attribute>
            <xsl:attribute name="IAID"><xsl:value-of select="@IAID"/></xsl:attribute> 
            <xsl:attribute name="parentIAID"><xsl:value-of select="../record[@refno=$parent-ref]/@IAID"/></xsl:attribute>       
        </record>      
    </xsl:template>
    
    
    
</xsl:stylesheet>