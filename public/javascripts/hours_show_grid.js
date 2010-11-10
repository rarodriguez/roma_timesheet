var hours_grid = ""; 
$(document).ready( function() {
  var lastsel2;
  hours_grid = jQuery("#hours_grid").jqGrid({
    colNames: ["id", "Initial Time","End Time","Date","Description", "Total Hours"],
    datatype: "local",
    width: 935,
    shrinkToFit: false,
    pgtext: false,
    pgbuttons: false,
    pginput: false,
    colModel: [
      {name: 'id',index: 'id',width: 0,hidden: true,sortable: false, key: true},
      {name: 'initial_time',index: 'initial_time',align: 'center',width: 100,resizable:false,editrules:{required:true,time:true},editoptions:{size:10},fixed: true,sortable: false},
      {name: 'end_time', index: 'end_time', align: 'center', width: 100, resizable:false, editrules:{required:true,time:true,custom:true,custom_func:end_time_check},editoptions:{size:10}, fixed: true, sortable: false},
      {name: 'date', index: 'date',datefmt:'mm-dd-yyyy', align: 'center', resizable:false, width: 100, sortable: false,editrules:{required:true,date:true}},
      {name: 'description',index: 'description',align: 'center',resizable:false,edittype:"textarea", editrules:{required:true},editoptions:{rows:"3",cols:"25"},width: 475,fixed: true,sortable: false },
      {name: 'total_hours',index: 'total_hours',align: 'center',width: 100,resizable:false,fixed: true,sortable: false},
    ],
    url: listing_grid,
    datatype: "json",
    mtype: "POST",
    height: 'auto',
    emptyrecords:"No timesheets to display",
    viewrecords: true,
    loadtext:"Loading...",
  });
});