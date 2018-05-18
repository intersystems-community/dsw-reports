Class RF.KHAB.Utils
{

ClassMethod Setup() As %Status
{
	set sc = ..Populate()
	do ##class(%DeepSee.Utils).%BuildCube("KHABCube")
	quit sc
}

ClassMethod Populate() As %Status
{
	do ..ImportXData("RF.KHAB.Region", "RegionXData")
	quit $$$OK
}

ClassMethod ImportXData(className As %String, xDataName As %String) As %Status
{
	#dim sc As %Status = $$$OK
	set sc= $CLASSMETHOD(className, "%KillExtent")

	set itemsCount = 0

	try{

		if $$$ISERR(sc)
		{
			write !, $System.Status.DisplayError(sc)
			$$$THROWONERROR(sc,sc)
		}

		#dim stream As %Stream.Object = ##class(%Dictionary.CompiledXData).%OpenId("RF.KHAB.Utils"_"||"_xDataName).Data
		#dim reader As %XML.Reader = ##class(%XML.Reader).%New()

		set sc = reader.OpenStream(stream, "literal")
		$$$THROWONERROR(sc,sc)

		do reader.Correlate($piece(className, ".", *), className)

		while reader.Next(.obj, .sc)
		{
			if $$$ISERR(sc)
			{
				write !, $System.Status.DisplayError(sc)
				$$$THROWONERROR(sc,sc)
			}

			set sc = obj.%Save()

			if $$$ISERR(sc)
			{
				write !, $System.Status.DisplayError(sc)
				$$$THROWONERROR(sc,sc)
			}

			set obj = ""
			set itemsCount = itemsCount + 1
		}
	}
	catch(ex){
		w !, ex.Name_" "_ex.Location
	}

	write !,"Import - "_itemsCount_" objects of class "_className
	
	Quit $$$OK
}

XData RegionXData
{
<RegionXData>
    <Region>
        <Name>Аяно-Майский район</Name>
        <Key>Аяно-Майский район</Key>
        <Population>1971</Population>
    </Region>
    <Region>
        <Name>Охотский район</Name>
        <Key>Охотский район</Key>
        <Population>6717</Population>
    </Region>
    <Region>
        <Name>Тугуро-Чумиканский район</Name>
        <Key>Тугуро-Чумиканский район</Key>
        <Population>1972</Population>
    </Region>
    <Region>
        <Name>Имени Полины Осипенко район</Name>
        <Key>Имени Полины Осипенко район</Key>
        <Population>4627</Population>
    </Region>
    <Region>
        <Name>Вяземский район</Name>
        <Key>Вяземский район</Key>
        <Population>21238</Population>
    </Region>
    <Region>
        <Name>Бикинский район</Name>
        <Key>Бикинский район</Key>
        <Population>22641</Population>
    </Region>
    <Region>
        <Name>Хабаровский район</Name>
        <Key>Хабаровский район</Key>
        <Population>90180</Population>
    </Region>
    <Region>
        <Name>Николаевский район</Name>
        <Key>Николаевский район</Key>
        <Population>28331</Population>
    </Region>
    <Region>
        <Name>Ульчский район</Name>
        <Key>Ульчский район</Key>
        <Population>16044</Population>
    </Region>
    <Region>
        <Name>Верхнебуреинский район</Name>
        <Key>Верхнебуреинский район</Key>
        <Population>25351</Population>
    </Region>
    <Region>
        <Name>Амурский район</Name>
        <Key>Амурский район</Key>
        <Population>61291</Population>
    </Region>
    <Region>
        <Name>Комсомольск-на-Амуре</Name>
        <Key>Комсомольск-на-Амуре</Key>
        <Population>251283</Population>
    </Region>
    <Region>
        <Name>Солнечный район</Name>
        <Key>Солнечный район</Key>
        <Population>30809</Population>
    </Region>
    <Region>
        <Name>Ванинский район</Name>
        <Key>Ванинский район</Key>
        <Population>34316</Population>
    </Region>
    <Region>
        <Name>Имени Лазо район</Name>
        <Key>Имени Лазо район</Key>
        <Population>42238</Population>
    </Region>
    <Region>
        <Name>Комсомольский район</Name>
        <Key>Комсомольский район</Key>
        <Population>28000</Population>
    </Region>
    <Region>
        <Name>Нанайский район</Name>
        <Key>Нанайский район</Key>
        <Population>16332</Population>
    </Region>
    <Region>
        <Name>Советско-Гаванский район</Name>
        <Key>Советско-Гаванский район</Key>
        <Population>40051</Population>
    </Region>
    <Region>
        <Name>Хабаровск</Name>
        <Key>Хабаровск</Key>
        <Population>611160</Population>
    </Region>
</RegionXData>
}

}

