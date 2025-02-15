#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СозданиеСпискаНаСервере(Дата, СоздатьОбъект) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДоговорыКонтрагентов.Владелец КАК Контрагент,
	               |	ДоговорыКонтрагентов.Ссылка КАК Ссылка,
	               |	ДоговорыКонтрагентов.Организация КАК Организация,
	               |	ДоговорыКонтрагентов.ВКМ_СуммаАбонентскойПлаты КАК ВКМ_СуммаАбонентскойПлаты
	               |ПОМЕСТИТЬ ВТ_ДанныеДог
	               |ИЗ
	               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	               |ГДЕ
	               |	&Дата МЕЖДУ ДоговорыКонтрагентов.ВКМ_НачалоДействияДоговора И ДоговорыКонтрагентов.ВКМ_КонецДействияДоговора
	               |	И ДоговорыКонтрагентов.ВидДоговора = &АбонентскаяПлата
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
	               |	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
	               |	РеализацияТоваровУслуг.Договор КАК Договор
	               |ПОМЕСТИТЬ ВТ_ДанныеРеализ
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |ГДЕ
	               |	РеализацияТоваровУслуг.Дата МЕЖДУ &ДатаНачало И &ДатаОкончание
	               |	И РеализацияТоваровУслуг.ПометкаУдаления = ЛОЖЬ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ДанныеДог.Ссылка КАК Договор,
	               |	ВТ_ДанныеРеализ.Ссылка КАК Реализация,
	               |	ВТ_ДанныеДог.Организация КАК Организация,
	               |	ВТ_ДанныеДог.Контрагент КАК Контрагент,
	               |	ВТ_ДанныеДог.ВКМ_СуммаАбонентскойПлаты КАК ВКМ_СуммаАбонентскойПлаты
	               |ИЗ
	               |	ВТ_ДанныеДог КАК ВТ_ДанныеДог
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеРеализ КАК ВТ_ДанныеРеализ
	               |		ПО ВТ_ДанныеДог.Ссылка = ВТ_ДанныеРеализ.Договор";

	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ДатаНачало", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончание", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("АбонентскаяПлата", Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскаяПлата);

	Результат = Запрос.Выполнить().Выбрать();

	МассивРеализаций = Новый Массив;

	Пока Результат.Следующий() Цикл 
		
		РеализацииСтруктура = Новый Структура; 
		
		Если СоздатьОбъект Тогда  
			
			Если НЕ ЗначениеЗаполнено(Результат.Реализация) Тогда
				
				Если Результат.ВКМ_СуммаАбонентскойПлаты > 0 Тогда
					НоваяРеализация = СозданиеРеализации(Результат, КонецМесяца(Дата));
				КонецЕсли;
				
				РеализацииСтруктура.Вставить("Договор", Результат.Договор);
				РеализацииСтруктура.Вставить("Реализация", НоваяРеализация);    
				
			Иначе    
				
				РеализацииСтруктура.Вставить("Договор", Результат.Договор);
				РеализацииСтруктура.Вставить("Реализация", Результат.Реализация);     
				
			КонецЕсли; 
			
		Иначе
			РеализацииСтруктура.Вставить("Договор", Результат.Договор);
			РеализацииСтруктура.Вставить("Реализация", Результат.Реализация);     
			
		КонецЕсли;

		МассивРеализаций.Добавить(РеализацииСтруктура);

	КонецЦикла;

	Возврат МассивРеализаций;

КонецФункции

Функция СозданиеРеализации(Результат, Дата)

	НовыйДок = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
	НовыйДок.Дата = Дата;
	НовыйДок.Договор = Результат.Договор;
	НовыйДок.Контрагент = Результат.Контрагент;
	НовыйДок.Организация = Результат.Организация;
	НовыйДок.ВыполнитьАвтозаполнение();
	НовыйДок.Ответственный = Пользователи.ТекущийПользователь();
	
	НовыйДок.Записать(РежимЗаписиДокумента.Проведение);

	Возврат НовыйДок.Ссылка;

КонецФункции

#КонецОбласти

#КонецЕсли