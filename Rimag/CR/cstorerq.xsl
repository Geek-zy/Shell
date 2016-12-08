
<!--
dcm-cloud_server ==> vi /usr/local/dcm4chee/server/default/conf/dcm4chee-ae/MOD_AET/cstorerq.xsl
-->

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" indent="no"/>
  <xsl:template match="/dataset">
    <dataset>
      <attr tag="00080005" vr="CS">GB18030</attr>

     <xsl:if test = "attr[@tag='00080080'] = '海拉尔农垦总医院'">
	<xsl:if test = "attr[@tag='00080060'] = 'CR'">
	   <xsl:if test = "attr[@tag='00081010'] = 'ru0'">
	      <xsl:choose>

        	  <xsl:when test = "attr[@tag='00180015'] = 'HEAD'">
                	<attr tag="00431014" vr="LO">NMGHLENKYYCR1</attr>
        	  </xsl:when>

		  <xsl:when test = "attr[@tag='00180015'] = 'BREAST'">
                	<attr tag="00431014" vr="LO">NMGHLENKYYCR2</attr>
		  </xsl:when>

		  <xsl:otherwise>
                	<attr tag="00431014" vr="LO">NMGHLENKYYCR3</attr>
		  </xsl:otherwise>

	      </xsl:choose>
	   </xsl:if>
	</xsl:if>
     </xsl:if>

   </dataset>
</xsl:template>
</xsl:stylesheet>
