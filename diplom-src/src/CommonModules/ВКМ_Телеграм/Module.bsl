#Область ПрограммныйИнтерфейс

Процедура ТГУведомление() Экспорт

	HTTPСоединение = Новый HTTPСоединение("api.telegram.org", 443, , , , , Новый ЗащищенноеСоединениеOpenSSL);

	ДанныеДляЗапроса = "bot" + Константы.ВКМ_ТокенУправленияТелеграмБота.Получить() + "/sendMessage";
	HTTPЗапрос = Новый HTTPЗапрос(ДанныеДляЗапроса);

	HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/json");

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВКМ_УведомленияТелеграмБоту.Ссылка КАК Ссылка,
	               |	ВКМ_УведомленияТелеграмБоту.ТекстСообщения КАК ТекстСообщения
	               |ИЗ
	               |	Справочник.ВКМ_УведомленияТелеграмБоту КАК ВКМ_УведомленияТелеграмБоту";

	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		Сообщение = Новый Структура;
		Сообщение.Вставить("chat_id", Константы.ВКМ_ИдентификаторГруппыДляОповещения.Получить());
		Сообщение.Вставить("text", Выборка.ТекстСообщения);

		СтрокаJSON = СтрокаJSON(Сообщение);

		HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаJSON);

		HTTPОтвет = HTTPСоединение.Получить(HTTPЗапрос);

		Если HTTPОтвет.КодСостояния = 200 Тогда
			ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокОбъект.Удалить();
		Иначе
			ИиформацияОбОшибке = ИнформацияОбОшибке();

			ЗаписьЖурналаРегистрации("HTTPСервисы.Ошибка", УровеньЖурналаРегистрации.Ошибка, , ,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИиформацияОбОшибке));

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтрокаJSON(ОбъектJSON)

	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(, Символы.Таб);

	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку(ПараметрыЗаписи);
	ЗаписатьJSON(Запись, ОбъектJSON);

	Возврат Запись.Закрыть();

КонецФункции

#КонецОбласти