<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tna="http://nationalarchives.gov.uk/metadata/tna#"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:output method="text" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="iaid-lookup" select="document('IAID-Lookup.xml')"/>
    <xsl:variable name="transfer-id" select="generate-id(current())" />
    
    <xsl:template match="DScribeRecord">
        <xsl:text>{
        "iaid": "</xsl:text>
        <xsl:value-of select="$iaid-lookup//record[@refno=current()/RefNo]/@IAID"/>
        <xsl:text>",
        "parentId": "</xsl:text>
            <xsl:value-of select="$iaid-lookup//record[@refno=current()/RefNo]/@parentIAID"/>
        <xsl:text>",
        "legalStatus": "Not Public Record(s)",
        "catalogueId": 0,
        </xsl:text>
            <xsl:apply-templates />  
        <xsl:if test="UserText2||Arrangement">
            <!--<xsl:call-template name="SystemOfArrangement" /> -->
        </xsl:if>
        <xsl:text>"heldBy": 
        [
            {
                "xReferenceId": "A13530124",
                "xReferenceCode": "66",
                "xReferenceName": "The National Archives, Kew"
            }
        ]
    },</xsl:text>
    </xsl:template>
<!--    
    <xsl:template match="RefNo">
        <xsl:text>"citableReference": "Y</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="Language">
        <xsl:text>"language": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="Title">
        <xsl:text>"title": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="CreatorName">
        <xsl:text>"creatorName": 
        [
            {
            "description": "</xsl:text><xsl:value-of select="text()"/><xsl:text>"
            }
        ],
        </xsl:text>
    </xsl:template>  
    
    <!- TO DO: Need to change to output dates in YYYY MMM dd or YYYY MMM ddd - YYYY MMM ddd format ->
    <xsl:template match="Date">
        <xsl:text>"coveringDates": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="Extent">
        <xsl:choose>
            <xsl:when test="contains(text(), 'and')">
                <xsl:analyze-string select="substring-before(text(), ' and')" regex="(\d)\s*([\w &amp;]*)">
                    <xsl:matching-substring>
                        <xsl:text>"physicalDescriptionExtent": "</xsl:text><xsl:value-of select="regex-group(1)"/><xsl:text>",
        </xsl:text>
                        <xsl:text>"physicalDescriptionForm": "</xsl:text><xsl:value-of select="regex-group(2)"/><xsl:text>",
        </xsl:text>
                    </xsl:matching-substring>
                </xsl:analyze-string>               
            </xsl:when>
            <xsl:otherwise>
                <xsl:analyze-string select="text()" regex="(\d)\s+([\w &amp;]*)">
                    <xsl:matching-substring>
                        <xsl:text>"physicalDescriptionExtent": "</xsl:text><xsl:value-of select="regex-group(1)"/><xsl:text>",
        </xsl:text>
                        <xsl:text>"physicalDescriptionForm": "</xsl:text><xsl:value-of select="regex-group(2)"/><xsl:text>",
        </xsl:text>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="PhysicalDescription">
        <xsl:text>"physicalCondition": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="PublnNote">
        <xsl:text>"note": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template> 
    
    <xsl:template match="AccessConditions">
        <xsl:text>"restrictionsOnUse": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template> 
    
    <xsl:template match="Arrangement">
        <xsl:text>"arrangement": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template> 
 
    <xsl:template match="AltRefNo">
        <xsl:text>"formerReferencePro": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template> 

    <xsl:template match="Sequence">
        <xsl:text>"formerReferenceDep": "</xsl:text><xsl:value-of select="text()"/><xsl:text>",
        </xsl:text>
    </xsl:template> 

    <xsl:template match="AdminHistory">
        <xsl:text>"administrativeBackground": "</xsl:text><xsl:value-of select="AdminHistory"/><xsl:text>",
        </xsl:text>
    </xsl:template> 
 
    <xsl:template name="SystemOfArrangement">
        <xsl:text>"arrangement": "</xsl:text>
        <xsl:if test="User_Text_2"><xsl:text>Former Fileplan Location: </xsl:text><xsl:value-of select="User_Text_2"/><xsl:text>
            </xsl:text></xsl:if>            
        <xsl:if test="Arrangement"><xsl:text>Arrangement: </xsl:text><xsl:value-of select="Arrangement"/></xsl:if>
        <xsl:text>",
        </xsl:text>
    </xsl:template> 
 -->
    <xsl:template match="Description">
        <xsl:text>"scopeContent": 
        {
            "description":"</xsl:text><xsl:value-of select="text()"/><xsl:text>"
        },
        </xsl:text>
    </xsl:template>
 <!--  
    <xsl:template match="//DScribeRecord/Level">
        <xsl:text>"catalogueLevel":</xsl:text> 
        <xsl:choose>
            <!- level = Item ->
            <xsl:when test="./text()='Item'">10</xsl:when>
            
            <!- level = File ->
            <xsl:when test="./text()='File'">9</xsl:when>
            
            <!- level = Sub sub series ->
            <xsl:when test="./text()='Sub sub series'">8</xsl:when>
            
            <!- level = Sub series ->
            <xsl:when test="./text()='Sub series'">7</xsl:when>
            
            <!- level = Series ->
            <xsl:when test="./text()='Series'">6</xsl:when>    
            
            <!- level = Sub sub sub sub fonds ->
            <xsl:when test="./text()='Sub sub sub sub fonds'">5</xsl:when>  
            
            <!- level = Sub sub sub fonds ->
            <xsl:when test="./text()='Sub sub sub fonds'">4</xsl:when> 
            
            <!- level = Sub sub fonds ->
            <xsl:when test="./text()='Sub sub fonds'">3</xsl:when> 
            
            <!- level = Sub fonds ->
            <xsl:when test="./text()='Sub fonds'">2</xsl:when>
            
            <!- level = Fonds ->
            <xsl:when test="./text()='Fonds'">1</xsl:when>
        </xsl:choose><xsl:text>,
        </xsl:text>
    </xsl:template>
 -->   
    <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>