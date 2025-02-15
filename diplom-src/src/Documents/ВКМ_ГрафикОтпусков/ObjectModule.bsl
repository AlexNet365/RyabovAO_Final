#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий  
   
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.ВКМ_УчетОтпусков.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.Сотрудник КАК Сотрудник,
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаОкончания КАК ДатаОкончания,
		|	РАЗНОСТЬДАТ(ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаНачала, ВКМ_ГрафикОтпусковОтпускаСотрудников.ДатаОкончания, ДЕНЬ) + 1 КАК КоличествоДней
		|ИЗ
		|	Документ.ВКМ_ГрафикОтпусков.ОтпускаСотрудников КАК ВКМ_ГрафикОтпусковОтпускаСотрудников
		|ГДЕ
		|	ВКМ_ГрафикОтпусковОтпускаСотрудников.Ссылка = &Ссылка
		|ИТОГИ
		|	СУММА(КоличествоДней)
		|ПО
		|	Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСотрудник = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);  
	
	ДнейОтпуска = 28;
	
	Пока ВыборкаСотрудник.Следующий() Цикл

		ПревышеноДней = ВыборкаСотрудник.КоличествоДней - ДнейОтпуска;
		
		Если ПревышеноДней > 0 Тогда     
			
			Отказ = Истина;

			ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Количество дней отпуска по сотруднику %1 превышено на %2", ВыборкаСотрудник.Сотрудник, ВыборкаСотрудник.КоличествоДней - ДнейОтпуска));  
			
		КонецЕсли; 
		
		Если Отказ Тогда
			Продолжить;
		КонецЕсли;    
		
		ВыборкаДетальныеЗаписи = ВыборкаСотрудник.Выбрать();
	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл    
			
			Движение = Движения.ВКМ_УчетОтпусков.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = ВыборкаДетальныеЗаписи.ДатаОкончания;
			Движение.Сотрудник = ВыборкаДетальныеЗаписи.Сотрудник;
			Движение.Значение = ВыборкаДетальныеЗаписи.КоличествоДней; 
			
		КонецЦикла;  
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти    

#КонецЕсли

