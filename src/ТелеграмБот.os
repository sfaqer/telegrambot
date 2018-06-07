#Использовать json
#Использовать logos

Перем ТокенАвторизации Экспорт;
Перем АдресСервиса	Экспорт;

Перем Соединение;
Перем ПарсерJSON;

Перем Лог;

Процедура Инициализировать() 
	
	АдресСервиса = "api.telegram.org";
	Соединение = Новый HTTPСоединение(АдресСервиса,,,443);
	ПарсерJSON = Новый ПарсерJSON;
	
	Лог = Логирование.ПолучитьЛог("oscript.lib.telegrambot");
	
КонецПроцедуры

#Область ПрограммныйИнтерфейс

Процедура УстановитьТокенАвторизации(Токен) Экспорт
	ТокенАвторизации = Токен;
КонецПроцедуры

Процедура УстановитьАдресСервиса(Адрес) Экспорт
	АдресСервиса = Адрес;
	Соединение = Новый HTTPСоединение(АдресСервиса,,,443);
КонецПроцедуры

Функция УстановитьВебхук(Адрес) Экспорт
	
	https = "https://";	
	Если Сред(Адрес, 1, 8) <> https Тогда
		Адрес = https + Адрес;
	КонецЕсли;
	
	Возврат СделатьХук(Адрес);
	
КонецФункции

Функция УбратьВебхук() Экспорт
	
	Возврат СделатьХук("");
	
КонецФункции

Функция Отправить(Сообщение) Экспорт
	
	Команда = "sendMessage";
	Ресурс = "/bot" + ТокенАвторизации + "/" + Команда; 
	Запрос = Новый HTTPЗапрос(Ресурс);
	Запрос.Заголовки = ПолучитьЗаголовки();
	
	ТекстТелаЗапроса = ПарсерJSON.ЗаписатьJSON(Сообщение);
	КодированнаяСтрока = РаскодироватьСтроку(ТекстТелаЗапроса, СпособКодированияСтроки.КодировкаURL);
	Запрос.УстановитьТелоИзСтроки(КодированнаяСтрока);

	Попытка
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	Исключение
		Лог.Ошибка("Не удалось отправить для обработки" + Ресурс);
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ПрочитатьОтветЗапроса(Ответ);
	
КонецФункции

Функция ОтредактироватьКлавиатуру(Сообщение) Экспорт
	
	Команда = "editMessageReplyMarkup";
	Ресурс = "/bot" + ТокенАвторизации + "/" + Команда; 
	Запрос = Новый HTTPЗапрос(Ресурс);
	Запрос.Заголовки = ПолучитьЗаголовки();
	
	ТекстТелаЗапроса = ПарсерJSON.ЗаписатьJSON(Сообщение);
	КодированнаяСтрока = РаскодироватьСтроку(ТекстТелаЗапроса, СпособКодированияСтроки.КодировкаURL);
	Запрос.УстановитьТелоИзСтроки(КодированнаяСтрока);

	Попытка
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	Исключение
		Лог.Ошибка("Не удалось отправить для обработки" + Ресурс);
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ПрочитатьОтветЗапроса(Ответ);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьОтветЗапроса(Знач Ответ)
	
	ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
	Если ТелоОтвета = Неопределено Тогда
		ТелоОтвета = "";
	КонецЕсли;

	Лог.Отладка("Код состояния: %1", Ответ.КодСостояния);
	Лог.Отладка("Тело ответа: 
		|%1", ТелоОтвета);

	Результат = Неопределено;
	Если ЗначениеЗаполнено(ТелоОтвета) Тогда
		Результат = ПарсерJSON.ПрочитатьJSON(ТелоОтвета);
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ПолучитьЗаголовки()

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-type","application/json");

	Возврат Заголовки;

КонецФункции

Функция СделатьХук(Суффикс)
	
	Команда = "setWebhook";
	Ресурс = "/bot" + ТокенАвторизации + "/" + Команда + "?url=" + Суффикс; 
	Запрос = Новый HTTPЗапрос(Ресурс);

	Попытка
		Ответ = Соединение.Получить(Запрос);
	Исключение
		Лог.Ошибка("Не удалось выполнить запрос" + Ресурс);
		Возврат Неопределено;
	КонецПопытки;	
	
	Возврат ПрочитатьОтветЗапроса(Ответ);
	
КонецФункции

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////
// ТОЧКА ВХОДА
///////////////////////////////////////////////////////////////////////////////

Инициализировать();