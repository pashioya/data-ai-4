<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="text" indent="yes"/>
	<xsl:template match="Placemark[ExtendedData/SchemaData/SimpleData[@name='Gebruik'] = 'GEPLAND']"/>
	<xsl:template match="Placemark[not(ExtendedData/SchemaData/SimpleData[@name='Gebruik'])]"/>


	<xsl:template match="Placemark[ExtendedData/SchemaData/SimpleData[@name='Gebruik'] != 'GEPLAND']">
		<xsl:variable name="objectId" select="ExtendedData/SchemaData/SimpleData[@name='OBJECTID']"/>
		<xsl:variable name="type" select="ExtendedData/SchemaData/SimpleData[@name='Type_velo']"/>
		<xsl:variable name="location" select="ExtendedData/SchemaData/SimpleData/SimpleData[@name='Ligging']"/>
		<xsl:variable name="street" select="ExtendedData/SchemaData/SimpleData[@name='Straatnaam']"/>
		<xsl:variable name="houseNumber" select="ExtendedData/SchemaData/SimpleData[@name='Huisnummer']"/>
		<xsl:variable name="additionalInfo" select="ExtendedData/SchemaData/SimpleData[@name='Aanvulling']"/>
		<xsl:variable name="district" select="ExtendedData/SchemaData/SimpleData[@name='District']"/>
		<xsl:variable name="zipCode" select="ExtendedData/SchemaData/SimpleData[@name='Postcode']"/>
		<xsl:variable name="objectCode" select="ExtendedData/SchemaData/SimpleData[@name='Objectcode']"/>
		<xsl:variable name="planned" select="ExtendedData/SchemaData/SimpleData[@name='Gebruik']"/>
		<xsl:variable name="stationNr" select="substring($objectCode,string-length($objectCode)-2,string-length($objectCode))"/>
		<xsl:variable name="latitude" select="substring-before(Point/coordinates, ',')"/>
		<xsl:variable name="longitude" select="substring-after(Point/coordinates, ',')"/>
		<xsl:variable name="gpsCoord" select="concat('POINT(', $latitude, ' ', $longitude, ')')"/>
		<xsl:variable name="objectType" select="ExtendedData/SchemaData/SimpleData[@name='Objecttype']"/>


		<xsl:text>Insert Into Stations2(StationId, ObjectId, StationNr, Type, Street, Number, ZipCode, District, GPSCoord, AdditionalInfo) VALUES (</xsl:text>
		<xsl:text>'</xsl:text>
		<!-- counter that increments every time a new line is started -->
		<xsl:variable name="counter" select="count(preceding-sibling::Placemark) + 1 - 2"/>
		<xsl:value-of select="$counter"/>
		<xsl:text>'</xsl:text>
		<xsl:text>, </xsl:text>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$objectId"/>
		<xsl:text>'</xsl:text>
		<xsl:text>, </xsl:text>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="format-number($stationNr, '000')"/>
		<xsl:text>'</xsl:text>
		<xsl:text>, </xsl:text>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$type"/>
		<xsl:text>'</xsl:text>
		<xsl:text>, </xsl:text>
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($street)) > 0">
				<xsl:text>'</xsl:text>
				<xsl:value-of select="$street"/>
				<xsl:text>'</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>'NULL'</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, </xsl:text>
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($houseNumber)) > 0">
				<xsl:text>'</xsl:text>
				<xsl:value-of select="$houseNumber"/>
				<xsl:text>'</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>NULL</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, </xsl:text>
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($zipCode)) > 0">
				<xsl:text>'</xsl:text>
				<xsl:value-of select="$zipCode"/>
				<xsl:text>'</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>NULL</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, </xsl:text>
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($district)) > 0">
				<xsl:text>'</xsl:text>
				<xsl:value-of select="$district"/>
				<xsl:text>'</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>NULL</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, </xsl:text>
		<xsl:text>geometry::STGeomFromText('</xsl:text>
		<xsl:value-of select="$gpsCoord"/>
		<xsl:text>',4326)</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($additionalInfo)) > 0">
				<xsl:text>'</xsl:text>
				<xsl:value-of select="$additionalInfo"/>
				<xsl:text>'</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>NULL</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>)</xsl:text>
	</xsl:template>
</xsl:stylesheet>
