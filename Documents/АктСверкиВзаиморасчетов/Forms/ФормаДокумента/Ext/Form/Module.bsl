﻿// Расширение. "Сверка_"
// Данное расширение увеличивает функциональность документа "Акт сверки взаиморасчетов"
//
// Список улучшений:
// 1. Заполняются данные счетов-фактур в табличную часть. 
// Полезно для тех, кто использует в документообороте с контрагентами счета-фактуры или УПД
// Это улучшение дозаполняет табличную часть. Поэтому можно использовать как и в типовой печатной форме, так и в доработанных кем то формах.
//
// 2. В печатной форме отображаются начальные и конечные остатки по договорам. 
// При установленом флаге "Разбить по договорам" и выбранной печатной форме "Акт сверки (сальдо по договорам)" в печатную форму 
// выводится информация об остатках по договорам.
//
// 3. Заполнение табличной части по головному контрагенту. 
// В случае если выбран головной контрагент, то программа задает вопрос,
// как необходимо заполнить табличную часть "по всем контрагентам" или "по головному". В случае если выбран ответ "по всем",
// то в заполнении участвуют все контрагенты у которых выбранный контрагент установлен как головной. Если выбран ответ "по головному",
// то заполнение будет только по выбранному контрагенту.
//
// 4. Заполняется "Представитель организации" из ответственных лиц организации. При выборе или изменении организации выполняется 
// поиск и установка представителя организации.
//
// Список изменений:
// 1. Добавлены реквизиты формы:
// - ВыводитьНомераСчетовФактур - Булево
// - ВключатьОбособленные - Булево
// 2. Добавлены команды:
// - АктСверкиСальдоПоДоговорам
// - ЗаполнитьПоДаннымБухгалтерскогоУчетаРасширенная
// 3. Изменения формы:
// - Типовая команда - ПоДаннымОрганизацииЗаполнитьПоДаннымБухУчета - Установлено свойство "ТолькоВоВсехДействиях" - Истина
// - Добавлена команда в "ГруппаПечать" - АктСверкиСальдоПоДоговорам
// - Добавлена команда в "ГруппаПоДаннымОрганизацииЗаполнить" - ПоДаннымОрганизацииЗаполнитьПоДаннымБухгалтерскогоУчетаРасширенная
// - Добавлен реквизит в "ГруппаПечатнаяФорма" - ВыводитьНомераСчетовФактур

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура Сверка_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Код расширения должен выполнятся после типового кода ПриСозданииНаСервере
	// потому что вносятся изменения в механизм печати БСП
	УстановитьВыполнениеПослеОбработчиковСобытия("ПослеПриСозданииНаСервере");
	
КонецПроцедуры

&НаСервере
Процедура Сверка_ПриЧтенииНаСервере(ТекущийОбъект)
	
	Сверка_ПодготовитьФормуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сверка_ЗаполнитьПоДаннымБухгалтерскогоУчетаРасширенная(Команда)
	
	ОбособленныеПодразделенияКонтрагента = ОбособленныеПодразделенияКонтрагента(Объект.Контрагент);
	
	Если ОбособленныеПодразделенияКонтрагента.Количество() > 0 Тогда
		
		ТекстВопрос = ПодготовитьТекстВопросаПоЗаполнениюДляГоловногоКонтрагента(ОбособленныеПодразделенияКонтрагента, Объект.Контрагент);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     "По всем");
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    "По головному");
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, "Отмена");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗаполнитьПоДаннымУчетаОбособленныеЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопрос, Кнопки);
		
	Иначе
		
		ЗаполнитьДаннымиБухгалтерскогоУчетаНаКлиентеРасширенная();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сверка_АктСверкиСальдоПоДоговорам(Команда)
	
	ВыполнитьКомандуПечати(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Сверка_АктСверкиСальдоПоДоговорамСПечатьюИПодписью(Команда)
	
	ВыполнитьКомандуПечати(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Сверка_ДатаПриИзменении(Элемент)
	
	Объект.ПредставительОрганизации = ПредставительОрганизации(Объект.Организация, Объект.Дата)
	
КонецПроцедуры

&НаКлиенте
Процедура Сверка_ОрганизацияПриИзменении(Элемент)
	
	Объект.ПредставительОрганизации = ПредставительОрганизации(Объект.Организация, Объект.Дата)
	
КонецПроцедуры

&НаКлиенте
Процедура Сверка_СверкаСогласованаПриИзменении(Элемент)
	
	Элементы.ВыводитьНомераСчетовФактур.Доступность = НЕ Объект.СверкаСогласована;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеДаннымиБухгалтерскогоУчета

&НаКлиенте
Процедура ЗаполнитьДаннымиБухгалтерскогоУчетаНаКлиентеРасширенная()

	// СтандартныеПодсистемы.ОценкаПроизводительности
	УИДЗамераЗаполнения = ОценкаПроизводительностиКлиентСервер.НачатьРучнойЗамерВремени("ЗаполнениеАктаСверкиВзаиморасчетовРасширенная");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
	Результат = ЗаполнитьПоДаннымБухгалтерскогоУчетаРасширенная();
	
	Если ТипЗнч(Результат) = Тип("Структура") И НЕ Результат.ЗаданиеВыполнено Тогда
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
	Иначе
		
		ЗафиксироватьДлительностьКлючевойОперации();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПоДаннымБухгалтерскогоУчетаРасширенная()
	
	//проверим заполненность обязательных реквизитов
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Истина;
	КонецЕсли;
	
	СтруктураПараметров = ПодготовитьСтруктуруПараметров();
	Если СтруктураПараметров = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор, 
		"Обработки.Сверка_СлужебнаяОбработка.ПодготовитьДанныеДляЗаполнения", 
		СтруктураПараметров, 
		"ЗаполнитьПоДаннымОрганизацииРасширенная");
		
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПодготовитьСтруктуруПараметров()

	// Расширение "Сверка_"
	// Функция выделена из типовой процедуры ЗаполнитьПоДаннымБухгалтерскогоУчета()
	// Типовой код оставлен для совместимости - в случае если будут внесены изменения в типовую
	// можно по аналогии внести изменения в эту процедуру.
	//
	// Список изменений:
	// 1. Добавлен параметр "ВключатьОбособленные"
	// 2. Добавлен параметр "ВыводитьНомераСчетовФактур"
	
	СтруктураПараметров = Новый Структура;
	
	ФильтрСписокСчетов = Новый Массив();
	Для каждого СтрокаСчета Из Объект.СписокСчетов Цикл
		Если ЗначениеЗаполнено(СтрокаСчета.Счет) И СтрокаСчета.УчаствуетВРасчетах Тогда
			ФильтрСписокСчетов.Добавить(СтрокаСчета.Счет);
		КонецЕсли; 
	КонецЦикла; 
	
	Если ФильтрСписокСчетов.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru='Не задан список счетов, по которым производится сверка.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , "Объект.СписокСчетов");
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ФильтрСписокСчетов", ФильтрСписокСчетов);
	
	СтруктураПараметров.Вставить("ДатаНачалаВключая", 
		?(НЕ ЗначениеЗаполнено(Объект.ДатаНачала), Неопределено, 
			Новый Граница (Объект.ДатаНачала, ВидГраницы.Включая)));
	СтруктураПараметров.Вставить("ДатаНачалаИсключая", 
		?(НЕ ЗначениеЗаполнено(Объект.ДатаНачала), Неопределено, 
			Новый Граница (Объект.ДатаНачала, ВидГраницы.Исключая)));
	СтруктураПараметров.Вставить("ДатаОкончания", 
		?(НЕ ЗначениеЗаполнено(Объект.ДатаОкончания), Неопределено, 
			Новый Граница(КонецДня(Объект.ДатаОкончания), ВидГраницы.Включая)));
	СтруктураПараметров.Вставить("Организация", Объект.Организация);
	СтруктураПараметров.Вставить("Контрагент", Объект.Контрагент);
	СтруктураПараметров.Вставить("Валюта",
		?(НЕ ЗначениеЗаполнено(Объект.ВалютаДокумента) 
		ИЛИ (Объект.ВалютаДокумента = ВалютаРегламентированногоУчета), Неопределено, 
			Объект.ВалютаДокумента));
	
	АналитикаРасчетов = Новый Массив();
	АналитикаРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	АналитикаРасчетов.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	СтруктураПараметров.Вставить("АналитикаРасчетов", АналитикаРасчетов);
	
	СтруктураПараметров.Вставить("ДоговорКонтрагента", 
		?(НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента), Неопределено, 
			Объект.ДоговорКонтрагента));
		
	СтруктураПараметров.Вставить("ВыводитьПолныеНазванияДокументов", Объект.ВыводитьПолныеНазванияДокументов);
	СтруктураПараметров.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("РазбитьПоДоговорам", Объект.РазбитьПоДоговорам);
	СтруктураПараметров.Вставить("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	
	// Добавим параметры обеспечивающие логику расширения "Сверка_"
	СтруктураПараметров.Вставить("ВключатьОбособленные", ВключатьОбособленные);
	СтруктураПараметров.Вставить("ВыводитьНомераСчетовФактур", ВыводитьНомераСчетовФактур);
	
	Возврат СтруктураПараметров;

КонецФункции

&НаСервереБезКонтекста
// Функция возвращает массив обособленных подразделений контрагента
//
// Параметры:
//    Контрагент - Справочник.Контрагенты - Головной контрагент, у которого требуется найти обособленные подразделения
// Возвращаемое значение:
//    Массив - Массив обособленных подразделений.
//
Функция ОбособленныеПодразделенияКонтрагента(Знач Контрагент);

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК ОбособленноеПодразделение
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка <> &Контрагент
	|	И Контрагенты.ГоловнойКонтрагент = &Контрагент";
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый Массив;
	Иначе
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ОбособленноеПодразделение");
	КонецЕсли;
		
КонецФункции

&НаКлиенте
// Функция формирует текст вопроса исходя из количества обособленных подраздлений контрагента
//
Функция ПодготовитьТекстВопросаПоЗаполнениюДляГоловногоКонтрагента(ОбособленныеПодразделенияКонтрагента, Контрагент);
	
	КоличествоОтображаемыхПодразделений = 5;
	
	Если ОбособленныеПодразделенияКонтрагента.Количество() > КоличествоОтображаемыхПодразделений Тогда
		// Если подразделений больше, чем мы хотим отображать, 
		// то расскажем лишь о некоторых
		ШаблонВопроса = НСтр("ru='Контрагент %1 является головным для
			|%2
			|
			|Включая:
			|%3
			|
			|По каким контрагентам заполнить табличную часть?'");
		КоличествоОбособленныхПодразделений = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
			ОбособленныеПодразделенияКонтрагента.Количество(),
			"обособленного подразделения, обособленных подразделений, обособленных подразделений");
		ОтображаемыеПодразделения = Новый Массив;
		Для Каждого ОбособленноеПодразделение Из ОбособленныеПодразделенияКонтрагента Цикл
			Если ОтображаемыеПодразделения.Количество() = КоличествоОтображаемыхПодразделений Тогда
				Прервать;
			КонецЕсли;
			ОтображаемыеПодразделения.Добавить(ОбособленноеПодразделение);
		КонецЦикла;
		ТекстОбособленныеПодразделения = СтрСоединить(ОтображаемыеПодразделения, Символы.ПС);
		ТекстВопроса = СтрШаблон(ШаблонВопроса, Контрагент, КоличествоОбособленныхПодразделений, ТекстОбособленныеПодразделения);
	Иначе
		// Если обособленных подразделений немного, то покажем их все.
		ШаблонВопроса = НСтр("ru='Контрагент %1 является головным для
			|
			|%2
			|
			|По каким контрагентам заполнить табличную часть?'");
		ТекстОбособленныеПодразделения = СтрСоединить(ОбособленныеПодразделенияКонтрагента, Символы.ПС);
		ТекстВопроса = СтрШаблон(ШаблонВопроса, Контрагент, ТекстОбособленныеПодразделения);
	КонецЕсли;
	
	Возврат ТекстВопроса;
	
КонецФункции

&НаКлиенте
Процедура ВопросЗаполнитьПоДаннымУчетаОбособленныеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		// Не заполняем
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		// Заполняем по всем контрагентам
		ВключатьОбособленные = Истина;
		Объект.ДоговорКонтрагента = Неопределено;
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
	ЗаполнитьДаннымиБухгалтерскогоУчетаНаКлиентеРасширенная();
	ВключатьОбособленные = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

&НаКлиенте
Процедура ВыполнитьКомандуПечати(СПечатью)

	Если Объект.Ссылка.Пустая() Тогда 
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
			|Печать ""Акта сверки"" возможна только после записи данных.
			|Данные будут записаны.'");
		ДополнительныеПараметры = Новый Структура("СПечатью", СПечатью);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗаписатьАктСверкиПередПечатьюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		Если Модифицированность Тогда
			Записать();
		КонецЕсли;
		ВыполнитьПечатьАктаСверки(СПечатью);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаписатьАктСверкиПередПечатьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		Записать();
		Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПечатьАктаСверки(ДополнительныеПараметры.СПечатью);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПечатьАктаСверки(СПечатью)
	
	ОбъектыПечати = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка);
	ПараметрыПечатиАктСверки = ПодготовитьПараметрыПечатиАктаСверкиНаСервере(ОбъектыПечати, СПечатью);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.Сверка_СлужебнаяОбработка", "АктСверки", ПараметрыПечатиАктСверки.ОбъектыПечати,
		ЭтотОбъект, ПараметрыПечатиАктСверки.ПараметрыПечати);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьПараметрыПечатиАктаСверкиНаСервере(Знач ОбъектыПечати, Знач СПечатью)
	
	Возврат Обработки.Сверка_СлужебнаяОбработка.ПодготовитьПараметрыПечатиАктаСверкиНаСервере(ОбъектыПечати, СПечатью)
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПослеПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДополнительныйПараметр)

	Если Параметры.Ключ.Пустая() Тогда
		Сверка_ПодготовитьФормуНаСервере();
	КонецЕсли;
		
	Элементы.ГруппаПечать.Вид = ВидГруппыФормы.Подменю;
	
КонецПроцедуры

&НаСервере
Процедура Сверка_ПодготовитьФормуНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Организация) И НЕ ЗначениеЗаполнено(Объект.ПредставительОрганизации) Тогда
		Объект.ПредставительОрганизации = ПредставительОрганизации(Объект.Организация, Объект.Дата);
	КонецЕсли;
	
	// Проверим, нужно ли отображать кнопку печати с печатью и подписью.
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.АктСверкиВзаиморасчетов.ПФ_MXL_АктСверки");
	Элементы.АктСверкиСальдоПоДоговорамСПечатьюИПодписью.Видимость = 
		(Макет.Области.Найти("ПодвалСПечатьюИПодписью") <> Неопределено);
	
	ВыводитьНомераСчетовФактур = Истина; // По умолчанию считаем, что всегда необходимо выводить номера счетов-фактур.
	Элементы.ВыводитьНомераСчетовФактур.Доступность = НЕ Объект.СверкаСогласована;
	
КонецПроцедуры

&НаСервереБезКонтекста
// Функция возвращает руководителя организации из регистра сведений ОтветственныйЛица.
// Параметры:
//     Организация - Справочник.Организации - Организация для которой необходимо установить ответственное лицо
//     Дата        - Дата                   - Дата документа, дата на которую требуется ответственный
//
Функция ПредставительОрганизации(Знач Организация, Знач Дата)
	
	ОтветственныеЛицаОрганизации = ОтветственныеЛицаБП.ОтветственныеЛица(Организация, Дата);
	
	Если ЗначениеЗаполнено(ОтветственныеЛицаОрганизации.ГлавныйБухгалтер) Тогда
		// Если есть главный бухгалтер, то устанавливаем его
		Возврат ОтветственныеЛицаОрганизации.ГлавныйБухгалтер;
	Иначе
		// Если нет, то устанавливаем руководителя
		Возврат ОтветственныеЛицаОрганизации.Руководитель;
	КонецЕсли;
	
КонецФункции

#КонецОбласти