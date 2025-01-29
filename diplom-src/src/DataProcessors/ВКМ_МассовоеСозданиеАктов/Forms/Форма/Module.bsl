
#Область ОбработчикиКомандФормы   

&НаКлиенте
Процедура СоздатьСписок(Команда)

	НужноСоздатьРеализацию = Ложь;  
	
	ДлительнаяОперация = ВыполнениеНаСервере(НужноСоздатьРеализацию);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОповещениеОЗавершении", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры 

&НаКлиенте
Процедура СоздатьРеализацию(Команда)

	НужноСоздатьРеализацию  = Истина;  
	
	ДлительнаяОперация = ВыполнениеНаСервере(НужноСоздатьРеализацию);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОповещениеОЗавершении", ЭтотОбъект);   
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВыполнениеНаСервере(СоздатьРеализацию)
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(УникальныйИдентификатор,"Обработки.ВКМ_МассовоеСозданиеАктов.СозданиеСпискаНаСервере", Объект.Период, СоздатьРеализацию);

КонецФункции

&НаКлиенте
Процедура ОповещениеОЗавершении(Результат, ДополнительныеПараметры) Экспорт

	Если Результат.Статус = "Выполнено" Тогда
		МассивРеализаций = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ЗаполнитьДоговоры(МассивРеализаций);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДоговоры(МассивРеализаций)

	Объект.ДоговорыРеализации.Очистить();

	Для Каждого Документ Из МассивРеализаций Цикл
		НоваяСтрока = Объект.ДоговорыРеализации.Добавить();
		НоваяСтрока.Договор = Документ.Договор;
		НоваяСтрока.Реализация = Документ.Реализация;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти     

