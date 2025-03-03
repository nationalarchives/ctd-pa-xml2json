<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
   
    <xsl:output method="xml" indent="yes"/> 
 
    <xsl:template match="DScribeDatabase">
        <xml>
            <xsl:apply-templates select="DScribeRecord" />  
        </xml>
    </xsl:template>
 
    <xsl:template match="DScribeRecord">
        <record>
            <xsl:attribute name="refno"><xsl:value-of select="current()/RefNo"/></xsl:attribute>
            <xsl:attribute name="IAID"><xsl:value-of select="generate-id(current())"/></xsl:attribute> 
            <xsl:attribute name="parentIAID" />
        </record>      
    </xsl:template>
    
</xsl:stylesheet>