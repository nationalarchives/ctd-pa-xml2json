<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tna="http://nationalarchives.gov.uk/metadata/tna#"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="iaid-lookup" select="document('IAID-Lookup.xml')"/>
    <xsl:variable name="transfer-id" select="generate-id(current())" />
    
    <xsl:template match="DScribeDatabase">
        <xsl:copy-of select="xml-to-json(.)"/>
    </xsl:template>
    
    <xsl:template match="DScribeRecord">
        <InformationAsset>   
            <IAID><xsl:value-of select="$iaid-lookup//record[@refno=current()/RefNo]/@IAID"/></IAID>
            <ParentIAID><xsl:value-of select="$iaid-lookup//record[@refno=current()/RefNo]/@parentIAID"/></ParentIAID>
            <LegalStatus>Not Public Record(s)</LegalStatus>
            <CatalogueId>0</CatalogueId>
            <HeldBy>
                <HeldBy>
                    <Corporate_Body_Name_Text>The National Archives, Kew</Corporate_Body_Name_Text>
                </HeldBy>
            </HeldBy>
            <xsl:apply-templates />  
            <xsl:choose>
                <xsl:when test="RelatedMaterial">
                    <RelatedMaterials>
                        <RelatedMaterial>
                            <Description><xsl:value-of select="RelatedMaterial/text()"/></Description>
                        </RelatedMaterial>
                    </RelatedMaterials>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="CustodialHistory||AdminHistory">
                <xsl:call-template name="administrativeBackground" />
            </xsl:if>
        </InformationAsset>
    </xsl:template>
    
    <xsl:template match="RefNo">
        <Reference>Y<xsl:value-of select="text()"/></Reference>
    </xsl:template>
    
    <xsl:template match="Language">
        <Language><xsl:value-of select="text()"/></Language>
    </xsl:template>
    
    <xsl:template match="Title">
        <Title><xsl:value-of select="text()"/></Title>
    </xsl:template>
    
    <!-- TO DO: No BIA equivilent ? -->
    <xsl:template match="CreatorName"/>  
    
    <!-- TO DO: Need to change to output dates in YYYY MMM dd or YYYY MMM ddd - YYYY MMM ddd format -->
    <xsl:template match="Date">
        <CoveringDates><xsl:value-of select="text()"/></CoveringDates>
    </xsl:template>
    
    <xsl:template match="Extent">
        <xsl:choose>
            <xsl:when test="contains(text(), 'and')">
                <xsl:analyze-string select="substring-before(text(), ' and')" regex="(\d)\s*([\w &amp;]*)">
                    <xsl:matching-substring>
                        <PhysicalDescriptionExtent><xsl:value-of select="regex-group(1)"/></PhysicalDescriptionExtent>
                        <PhysicalDescriptionForm><xsl:value-of select="regex-group(2)"/></PhysicalDescriptionForm>
                    </xsl:matching-substring>
                </xsl:analyze-string>               
            </xsl:when>
            <xsl:otherwise>
                <xsl:analyze-string select="text()" regex="(\d)\s+([\w &amp;]*)">
                    <xsl:matching-substring>
                        <PhysicalDescriptionExtent><xsl:value-of select="regex-group(1)"/></PhysicalDescriptionExtent>
                        <PhysicalDescriptionForm><xsl:value-of select="regex-group(2)"/></PhysicalDescriptionForm>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="PhysicalDescription">
        <PhysicalCondition><xsl:value-of select="text()"/></PhysicalCondition>
    </xsl:template>
    
    <xsl:template match="PublnNote">
        <Note><xsl:value-of select="text()"/></Note>
    </xsl:template> 
    
    <xsl:template match="AccessConditions">
        <RestrictionOnUse><xsl:value-of select="text()"/></RestrictionOnUse>
    </xsl:template> 
    
    <xsl:template match="Arrangement">
        <Arrangement><xsl:value-of select="text()"/></Arrangement>
    </xsl:template> 
 
    <xsl:template match="AltRefNo">
        <FormerReferencePro><xsl:value-of select="text()"/></FormerReferencePro>
    </xsl:template> 

    <xsl:template match="Sequence">
        <FormerReferenceDep><xsl:value-of select="text()"/></FormerReferenceDep>
    </xsl:template> 

    <xsl:template name="administrativeBackground">
        <AdministrativeBackground>
            <xsl:if test="CustodialHistory">Custodial History: <xsl:value-of select="CustodialHistory"/><xsl:text>
            </xsl:text></xsl:if>            
            <xsl:if test="AdminHistory">Administration History: <xsl:value-of select="AdminHistory"/></xsl:if>
        </AdministrativeBackground>
    </xsl:template> 
 
    <xsl:template match="User_Text_2">
        <Arrangement>This born digital record was arranged under the following file structure: <xsl:value-of select="text()"/></Arrangement>
    </xsl:template> 
 
    <xsl:template match="Description">
        <ScopeContent>
            <Description>
                <xsl:value-of select="text()"/>
            </Description>
        </ScopeContent>
    </xsl:template>
    
    <xsl:template match="//DScribeRecord/Level">
        <xsl:choose>
            <!-- level = Item -->
            <xsl:when test="./text()='Item'">   
                <SourceLevelId>10</SourceLevelId>               
            </xsl:when>
            
            <!-- level = File -->
            <xsl:when test="./text()='File'">
                <SourceLevelId>9</SourceLevelId>
            </xsl:when>
            
            <!-- level = Sub sub series -->
            <xsl:when test="./text()='Sub sub series'">
                <SourceLevelId>8</SourceLevelId>
            </xsl:when>
            
            <!-- level = Sub series -->
            <xsl:when test="./text()='Sub series'">
                <SourceLevelId>7</SourceLevelId>
            </xsl:when>
            
            <!-- level = Series -->
            <xsl:when test="./text()='Series'">
                <SourceLevelId>6</SourceLevelId>
            </xsl:when>    
            
            <!-- level = Sub sub sub sub fonds -->
            <xsl:when test="./text()='Sub sub sub sub fonds'">
                <SourceLevelId>5</SourceLevelId>
            </xsl:when>  
            
            <!-- level = Sub sub sub fonds -->
            <xsl:when test="./text()='Sub sub sub fonds'">
                <SourceLevelId>4</SourceLevelId>
            </xsl:when> 
            
            <!-- level = Sub sub fonds -->
            <xsl:when test="./text()='Sub sub fonds'">
                <SourceLevelId>3</SourceLevelId>
            </xsl:when> 
            
            <!-- level = Sub fonds -->
            <xsl:when test="./text()='Sub fonds'">
                <SourceLevelId>2</SourceLevelId>
            </xsl:when>
            
            <!-- level = Fonds -->
            <xsl:when test="./text()='Fonds'">
                <SourceLevelId>1</SourceLevelId>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>