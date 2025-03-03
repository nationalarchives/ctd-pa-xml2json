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
    
    <!-- <xsl:variable name="json-escapes">
       <esc j="\\n" x="-"/>
        <esc j="\\s" x="*"/>
    </xsl:variable>
 
    <xsl:key name="json-escapes" match="esc" use="@j"/>  -->
    
   
    <xsl:template match="text()" mode="escaped">   
        <xsl:analyze-string select="." regex="\\|\n|[\s\s]+|&quot;">
            <xsl:matching-substring>
                <!--<xsl:text>~</xsl:text><xsl:value-of select="key('json-escapes', ., $json-escapes)/@x"/><xsl:text>~</xsl:text>-->
                <xsl:variable name="v" select="."/>
                <xsl:variable name="v" select="replace($v, '\\', '\\\\')"/>
                <xsl:variable name="v" select="replace($v, '&#10;', ' ')"/>
                <xsl:variable name="v" select="replace($v, '&quot;', '\\&quot;')"/>
                <xsl:variable name="v" select="replace($v, '  ', ' ')"/>
                <xsl:value-of select="$v"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template match="text()|@*"/>
   
   
    <xsl:template match="DScribeDatabase">
        <xsl:text>[
        </xsl:text>
        <xsl:for-each select="DScribeRecord">
            <xsl:apply-templates select="."/>
            <xsl:if test="position() != last()"><xsl:text>, 
            </xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
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
        
        <xsl:apply-templates select="*" />  
        
        <xsl:if test="UserText2||Arrangement">
            <xsl:call-template name="SystemOfArrangement" />
        </xsl:if>
        <xsl:text>"heldBy": 
        [
            {
                "xReferenceId": "A13530124",
                "xReferenceCode": "66",
                "xReferenceName": "The National Archives, Kew"
            }
        ]
    }</xsl:text>
    </xsl:template>
    
    <xsl:template match="RefNo">
        <xsl:text>"citableReference": "Y</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="Language">
        <xsl:text>"language": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="Title">
        <xsl:text>"title": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="CreatorName">
        <xsl:text>"creatorName": 
        [
            {</xsl:text>
        <xsl:analyze-string select="text()" regex="(\d+)([ \w]*)-(\d+)?([ \w]*)">
                    <xsl:matching-substring>
                        <xsl:if test="regex-group(1) != ''">
                            <xsl:text>
            "startDate": </xsl:text><xsl:value-of select="regex-group(1)"/><xsl:text>0101,</xsl:text></xsl:if>
                        <xsl:if test="contains(lower-case(regex-group(2)), 'century')">
                            <xsl:text>
            "startDate": </xsl:text><xsl:value-of select="number(regex-group(1)) - 1"/><xsl:text>000101,</xsl:text></xsl:if>
                        <xsl:if test="regex-group(3) != ''">
                            <xsl:text>
            "endDate": </xsl:text><xsl:value-of select="regex-group(3)"/><xsl:text>1231,</xsl:text></xsl:if>
                        <xsl:if test="contains(lower-case(regex-group(4)), 'century')">
                            <xsl:text>
            "endDate": </xsl:text><xsl:value-of select="regex-group(3)"/><xsl:text>991231,</xsl:text></xsl:if>
                    </xsl:matching-substring>
            </xsl:analyze-string> 
            <xsl:text>
            "description": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>"
            }
        ],
        </xsl:text>
    </xsl:template>  
    
    <!-- TO DO: Need to change to output dates in YYYY MMM dd or YYYY MMM ddd - YYYY MMM ddd format -->
    <xsl:template match="Date">
        <xsl:text>"coveringDates": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
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
            <xsl:when test="contains(text(), ',')">
                <xsl:analyze-string select="substring-before(text(), ' ,')" regex="(\d)\s*([\w &amp;]*)">
                    <xsl:matching-substring>
                        <xsl:text>"physicalDescriptionExtent": "</xsl:text><xsl:value-of select="regex-group(1)"/><xsl:text>",
        </xsl:text>
                        <xsl:text>"physicalDescriptionForm": "</xsl:text><xsl:value-of select="regex-group(2)"/><xsl:text>",
        </xsl:text>
                    </xsl:matching-substring>
                </xsl:analyze-string>               
            </xsl:when>
            <xsl:when test="contains(text(), ';')">
                <xsl:analyze-string select="substring-before(text(), ' ;')" regex="(\d)\s*([\w &amp;]*)">
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
        <xsl:text>"physicalCondition": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
        <xsl:analyze-string select="text()" regex="(\d+[cm]*x\d+[cm]*x?\d*[cm]*)|(A\d)">
            <xsl:matching-substring>
                <xsl:if test="regex-group(1) != '' or regex-group(2) != ''">
                    <xsl:text>"dimensions": "</xsl:text><xsl:value-of select="regex-group(1)"/><xsl:value-of select="regex-group(2)"/><xsl:text>",
        </xsl:text>    
                </xsl:if>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template match="PublnNote">
        <xsl:text>"publicationNote": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template> 
    
    <xsl:template match="Copyright">
        <xsl:text>"restrictionsOnUse": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template> 

    <xsl:template match="AccessConditions">
        <xsl:text>"accessConditions": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template> 

    <xsl:template match="AltRefNo">
        <xsl:text>"formerReferencePro": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template> 

    <xsl:template match="Sequence">
        <xsl:text>"formerReferenceDep": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template> 

    <xsl:template match="AdminHistory">
        <xsl:text>"administrativeBackground": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template> 
    
    <xsl:template match="CustodialHistory">
        <xsl:text>"custodialHistory": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template>

    <xsl:template match="Acquisition">
        <xsl:text>"immediateSourceOfAcquisition": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template>

    <xsl:template match="Appraisal">
        <xsl:text>"appraisalInformation": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="Accruals">
        <xsl:text>"Accruals": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="UserWrapped1">
        <xsl:text>"note": "</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>",
        </xsl:text>
    </xsl:template>

    <xsl:template name="SystemOfArrangement">
        <xsl:text>"arrangement": "</xsl:text>
        <xsl:if test="UserText2"><xsl:text>Former Fileplan Location: </xsl:text><xsl:value-of><xsl:apply-templates select="UserText2/text()" mode="escaped"/></xsl:value-of><xsl:text> </xsl:text></xsl:if>            
        <xsl:if test="Arrangement"><xsl:text>Arrangement: </xsl:text><xsl:value-of><xsl:apply-templates select="Arrangement/text()" mode="escaped"/></xsl:value-of></xsl:if>
        <xsl:text>",
        </xsl:text>
    </xsl:template> 
 
    <xsl:template match="Originals">
        <xsl:text>"locationOfOriginals": 
        [{
            "description":"</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>"
        }],
        </xsl:text>
    </xsl:template>

    <xsl:template match="Copies">
        <xsl:text>"copiesInformation": 
        [{
            "description":"</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>"
        }],
        </xsl:text>
    </xsl:template>

    <xsl:template match="FindingAids">
        <xsl:text>"unpublishedFindingAids": ["</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>"],
        </xsl:text>
    </xsl:template>

    <xsl:template match="Description">
        <xsl:text>"scopeContent": 
        {
            "description":"</xsl:text><xsl:value-of><xsl:apply-templates select="text()" mode="escaped"/></xsl:value-of><xsl:text>"
        },
        </xsl:text>
    </xsl:template>
    
    <xsl:template match="//DScribeRecord/Level">
        <!-- TO DO: Need to change test to be case insensitive -->
        <xsl:text>"catalogueLevel":</xsl:text> 
        <xsl:choose>
            <!-- level = Item -->
            <xsl:when test="lower-case(./text())='item'"> 10</xsl:when>
            
            <!-- level = File -->
            <xsl:when test="lower-case(./text())='file'"> 9</xsl:when>
            
            <!-- level = Sub sub series -->
            <xsl:when test="lower-case(./text())='sub sub series'"> 8</xsl:when>
            
            <!-- level = Sub series -->
            <xsl:when test="lower-case(./text())='sub series'"> 7</xsl:when>
            
            <!-- level = Series -->
            <xsl:when test="lower-case(./text())='series'"> 6</xsl:when>    
            
            <!-- level = Sub sub sub sub fonds -->
            <xsl:when test="lower-case(./text())='sub sub sub sub fonds'"> 5</xsl:when>  
            
            <!-- level = Sub sub sub fonds -->
            <xsl:when test="lower-case(./text())='sub sub sub fonds'"> 4</xsl:when> 
            
            <!-- level = Sub sub fonds -->
            <xsl:when test="lower-case(./text())='sub sub fonds'"> 3</xsl:when> 
            
            <!-- level = Sub fonds -->
            <xsl:when test="lower-case(./text())='sub fonds'"> 2</xsl:when>
            
            <!-- level = Fonds -->
            <xsl:when test="lower-case(./text())='fonds'"> 1</xsl:when>
            <xsl:otherwise>ERROR</xsl:otherwise>
        </xsl:choose><xsl:text>,
        </xsl:text>
    </xsl:template>
 
    <xsl:template match="AccessStatus">
        <xsl:choose>
            <xsl:when test="text() = 'Open'">
        <xsl:text>"closureCode": 0,
        </xsl:text>
            </xsl:when>
            
            <xsl:when test="text() = 'Closed'">
                <xsl:text>"closureType":"OU",
        </xsl:text>
                <xsl:variable name="closureCode" select="tokenize(../ClosedUntil, '/')[last()]"/>
                <xsl:if test="$closureCode != ''"><xsl:text>"closureCode": </xsl:text><xsl:value-of select="$closureCode"/><xsl:text>,
        </xsl:text></xsl:if>        
        <xsl:text>"closureStatus": "C",
        </xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ClosedUntil">
        <!-- Date format in XML is dd/MM/YYYY -->
        <xsl:variable name="dateString">
            <xsl:value-of select="substring(text(),7,4)"/><xsl:text>-</xsl:text>
            <xsl:value-of select="substring(text(),4,2)"/><xsl:text>-</xsl:text>
            <xsl:value-of select="substring(text(),1,2)"/>
        </xsl:variable>
        
        <xsl:text>"recordOpeningDate": "</xsl:text><xsl:value-of select="$dateString"/><!--<xsl:value-of select="xs:date($dateString) + xs:dayTimeDuration('P1D')"/>--><xsl:text>",
        </xsl:text>
    </xsl:template>
    
</xsl:stylesheet>