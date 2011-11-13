/**
* A KnockoutJs binding handler for the html tables javascript library DataTables.
*
* File:         cog.knockout.dataTables.js
* Version:      0.1
* Author:       Lucas Martin
* License:      Creative Commons Attribution 3.0 Unported License. http://creativecommons.org/licenses/by/3.0/ 
* 
* Copyright 2011, All Rights Reserved, Cognitive Shift http://www.cogshift.com  
*
* For more information about KnockoutJs or DataTables, see http://www.knockoutjs.com and http://www.datatables.com for details.                    
*/

ko.bindingHandlers['dataTable'] = {
    'init': function (element, valueAccessor, allBindingsAccessor, viewModel) {
        var binding = ko.utils.unwrapObservable(valueAccessor());

        var options = {};

        // ** Initialise the DataTables options object with the data-bind settings **

        // Clone the options object found in the data bindings.  This object will form the base for the DataTable initialisation object.
        if (binding.options)
            options = $.extend(options, binding.options);

        // Define the tables columns.
        if (binding.columns && binding.columns.length) {
            options.aoColumns = [];
            ko.utils.arrayForEach(binding.columns, function (col) {
                options.aoColumns.push({ mDataProp: col });
            })
        }

        // Register the row template to be used with the DataTable.
        if (binding.rowTemplate && binding.rowTemplate != '') {
            options.fnRowCallback = function (row, data, displayIndex, displayIndexFull) {
                ko.renderTemplate(binding.rowTemplate, data, null, row, "replaceChildren");
                // Remove the Ko databinding attribute from each row after it's been rendered using ko.renderTemplate so when 
                // ko.appplyBinding() is called on document load the row databinding attributes don't get processed again by Knockout.
                $(row).find('[data-bind]').removeAttr('data-bind');
                return row;
            }
        }

        // Set the data source of the DataTable.
        if (binding.dataSource) {
            var dataSource = ko.utils.unwrapObservable(binding.dataSource);

            // If the data source is a function that gets the data for us...
            if (typeof dataSource == 'function' && dataSource.length == 2) {
                // Register a fnServerData callback which calls the data source function when the DataTable requires data.
                options.fnServerData = function (source, criteria, callback) {
                    dataSource(ko.bindingHandlers['dataTable'].convertDataCriteria(criteria), function (result) {
                        callback({
                            aaData: ko.utils.unwrapObservable(result.Data),
                            iTotalRecords: ko.utils.unwrapObservable(result.TotalRecords),
                            iTotalDisplayRecords: ko.utils.unwrapObservable(result.DisplayedRecords)
                        });
                    });
                }

                // In this data source scenario, we are relying on the server processing.
                options.bProcessing = true;
                options.bServerSide = true;
            }
            // If the data source is a javascript array...
            else if (dataSource instanceof Array) {
                // Set it as the initial data source.
                options.aaData = binding.dataSource;
            }
            // If the dataSource was not a function that retrieves data, or a javascript object array containing data.
            else {
                throw 'The dataSource defined must either be a javascript object array, or a function that takes special parameters.';
            }
        }

        // If no fnRowCallback has been registered in the DataTable's options, then register the default fnRowCallback.
        // This default fnRowCallback function is called for every row in the data source.  The intention of this callback
        // is to build a table row that is bound it's associated record in the data source via knockout js.
        if (!options.fnRowCallback) {
            options.fnRowCallback = function (row, srcData, displayIndex, displayIndexFull) {
                var columns = this.fnSettings().aoColumns

                // Empty the row that has been build by the DataTable of any child elements.
                var destRow = $(row);
                destRow.html("");

                // For each column in the data table...
                ko.utils.arrayForEach(columns, function (column) {
                    var columnName = column.mDataProp;
                    // Create a new cell.
                    var newCell = $("<td></td>");
                    // Insert the cell in the current row.
                    destRow.append(newCell);
                    // bind the cell to the observable in the current data row.
                    ko.applyBindingsToNode(newCell[0], { text: srcData[columnName] }, srcData);
                });

                return destRow[0];
            }
        }

        $(element).dataTable(options);
    },
    'update': function (element, valueAccessor) {
        var binding = ko.utils.unwrapObservable(valueAccessor());

        // If a row template hasn't been defined in the bindings, then we're 
        if (ko.isObservable(binding.dataSource)) {
            var dataTable = $(element).dataTable();

            // Get a list of rows in the DataTable.
            var tableNodes = dataTable.fnGetNodes();

            // If the table contains rows...
            if (tableNodes.length) {
                // Unregister each of the table rows from knockout.
                ko.utils.arrayForEach(tableNodes, function (node) { ko.cleanNode(node); });
                // Clear the datatable of rows.
                dataTable.fnClearTable();
            }

            // Add the changed data to the DataTable.
            dataTable.fnAddData(ko.utils.unwrapObservable(binding.dataSource));
        }
    },

    /*
    // This function transforms the data format that DataTables uses to transfer paging and sorting information to the server
    // to something that is a little easier to work with on the server side.  The resulting object should look something like 
    // this in C#
    public class DataGridCriteria
    {
    public int RecordsToTake { get; set; }
    public int RecordsToSkip { get; set; }
    public string GlobalSearchText { get; set; }

    public ICollection<DataGridColumnCriteria> Columns { get; set; }
    }

    public class DataGridColumnCriteria
    {
    public string ColumnName { get; set; }
    public bool IsSorted { get; set; }
    public int SortOrder { get; set; }
    public string SearchText { get; set; }
    public bool IsSearchable { get; set; }
    public SortDirection SortDirection { get; set; }
    }

    public enum SortDirection
    {
    Ascending,
    Descending
    }
    */
    convertDataCriteria: function (srcOptions) {
        var getColIndex = function (name) {
            var matches = name.match("\\d+");

            if (matches && matches.length)
                return matches[0];

            return null;
        }

        var destOptions = { Columns: [] };

        // Figure out how many columns in in the data table.
        for (var i = 0; i < srcOptions.length; i++) {
            if (srcOptions[i].name == "iColumns") {
                for (var j = 0; j < srcOptions[i].value; j++)
                    destOptions.Columns.push(new Object());
                break;
            }
        }

        ko.utils.arrayForEach(srcOptions, function (item) {
            var colIndex = getColIndex(item.name);

            if (item.name == "iDisplayStart")
                destOptions.RecordsToSkip = item.value;
            else if (item.name == "iDisplayLength")
                destOptions.RecordsToTake = item.value;
            else if (item.name == "sSearch")
                destOptions.GlobalSearchText = item.value;
            else if (item.name.startsWith("bSearchable_"))
                destOptions.Columns[colIndex].IsSearchable = item.value;
            else if (item.name.startsWith("sSearch_"))
                destOptions.Columns[colIndex].SearchText = item.value;
            else if (item.name.startsWith("mDataProp_"))
                destOptions.Columns[colIndex].ColumnName = item.value;
            else if (item.name.startsWith("iSortCol_")) {
                destOptions.Columns[item.value].IsSorted = true;
                destOptions.Columns[item.value].SortOrder = colIndex;

                var sortOrder = ko.utils.arrayFilter(srcOptions, function (item) {
                    return item.name == "sSortDir_" + colIndex;
                });

                if (sortOrder.length && sortOrder[0].value == "desc")
                    destOptions.Columns[item.value].SortDirection = "Descending";
                else
                    destOptions.Columns[item.value].SortDirection = "Ascending";
            }
        });

        return destOptions;
    }
};