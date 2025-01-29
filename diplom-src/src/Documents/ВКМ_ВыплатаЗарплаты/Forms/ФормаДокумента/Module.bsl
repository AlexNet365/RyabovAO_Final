
&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник КАК Сотрудник,
		|	СУММА(ВКМ_ВзаиморасчетыССотрудникамиОстатки.СуммаОстаток) КАК СуммаОстаток,
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВидРасчета КАК ВидРасчета
		|ИЗ
		|	РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки(&Период, ) КАК ВКМ_ВзаиморасчетыССотрудникамиОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник,
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.ВидРасчета";
	
	Период = Новый Граница(Объект.Дата, ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Период", Период);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Объект.Выплаты.Очистить();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Строка = Объект.Выплаты.Добавить();
		Строка.Сотрудник = ВыборкаДетальныеЗаписи.Сотрудник;
		Строка.ВидРасчета = ВыборкаДетальныеЗаписи.ВидРасчета;
		Строка.Сумма = ВыборкаДетальныеЗаписи.СуммаОстаток;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры
