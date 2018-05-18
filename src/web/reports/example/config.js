/**
 * Общие настройки отчёта
 * @param params Параметы отправляемые в функцию обработки блоков.
 * @returns {{REPORT_NAME: string, BLOCKS: *[], NAMESPACE: string}}
 */
function getConfiguration(params) {
    if (params.namespace == undefined || params.namespace == null) params.namespace = "DSWREP";
    return {
        REPORT_NAME: "Report Example", // Заголовок отчёта
        BLOCKS: getReportBlocks(params),
        NAMESPACE: params.namespace // Значение области для отчёта
    }
}

/**
 * Функция получения настроек блоков с виджетами.
 * @param params Параметы. По умолчанию содержит сервер и область.
 * @returns {*[]}
 */
function getReportBlocks(params) {
    /**
     * block={
     *  title: String,                  // Заголовок блока
     *  note: String,                   // Замечания под блоком. Могут содержать HTML код
     *  widget: {                       // Настройки iframe виджета:
     *      url: String,                //  URL источника для iframe
     *      height: Number,             //  Высота iframe
     *      width: Number               //  Ширина iframe
     *  },
     *  totals:[{                       // Настройки значений вычисляемых с помощью MDX (значений может быть несколько):
     *      mdx: String                 //  MDX запрос
     *      strings: [{                 //  Строки значений из запроса (строк может быть несколько):
     *          title: String,          //      Заголовок строки. Может использовать HTML.
     *          value: String,          //      Значение строки по умолчанию
     *          value_append: String,   //      Суффикс для значения. Может использоваться для знаков %, $ и т.д.
     *                                  //          % преобразует значение в процентное. Может использовать HTML.
     *          row: Number             //      Номер строки MDX запроса, из которой берётся значение. По умолчанию 0.
     *      },{...}]
     *  },{...}]}
     *
     * Все поля обязательны. Если какое то поле вам не нужно оставьте пустую строку.
     */

    var server = params.server;
    var namespace = params.namespace;
    return [{
        title: "Khabarovsky krai",
        note: "Something note (only static)",
        widget: {
            url: server + "/dsw/index.html#!/d/KHAB/Khabarovsk%20Map.dashboard?widget=0&height=420&isLegend=true&ns=" + namespace,
            width: 495,
            height: 420
        },
        totals: [{
            mdx: "SELECT NON EMPTY [Region].[H1].[Region].CurrentMember.Properties(\"Population\") ON 0,"+
            "NON EMPTY {[Region].[H1].[Region].&[Хабаровск],[Region].[H1].[Region].&[Комсомольск-на-Амуре],"+
            "[Region].[H1].[Region].&[Комсомольский район]} ON 1 FROM [KHABCUBE]",
            strings: [{
                title: "Хабаровск: ",
                value: "None",
                value_append: " чел."
            }, {
                title: "Комсомольск-на-Амуре: <br />",
                value: "None",
                value_append: " чел.",
                row: 1
            }, {
                title: "Комсомольский район: <br />",
                value: "None",
                value_append: " чел.",
                row: 2
            }]
        }]
    }, {
        title: "Persons",
        note: "",
        widget: {
            url: server + "/dsw/index.html#!/d/KHAB/Khabarovsk%20Map.dashboard?widget=1&height=420&ns=" + namespace,
            width: 700,
            height: 420
        }
    }];
}